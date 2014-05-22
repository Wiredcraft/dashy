package main

import (
	"time"
	"io"
	"encoding/json"
	"errors"
	"path/filepath"
	"github.com/kylelemons/go-gypsy/yaml"
	"strconv"
	"github.com/garyburd/redigo/redis"
	"github.com/gorilla/websocket"
	"net/http"
	"fmt"
)

var session Session;

func main() {
	fmt.Println("starting dashy server on 8081 ab")
	router := http.NewServeMux()

	conn, _ := redis.Dial("tcp", ":6379")
	defer conn.Close()

	persistor := Persistor{connection: conn, incomingTimedEvents: make(<-chan *TimedEvent)}

	session = Session{connections: make(map[*connection]bool)}

	session.dataSources = DataSourcesFromConfigurationFiles()

	for _, dataSource := range session.dataSources {
		go dataSource.run()
		dataSource.registerPersistor <- &persistor
		dataSource.RegisterWebhookHandlers(router)
	}


	router.HandleFunc("/ws", wsHandler)
	router.HandleFunc("/reset-dashy-server", resetHandler)
	router.Handle("/", http.FileServer(http.Dir("build/web/")))

	s := &http.Server{
		Addr: ":8081",
		Handler: router,
	}

	panic(s.ListenAndServe())

}

type Session struct {
	dataSources []*DataSource
	connections map[*connection]bool
}

func (session Session) registerConnection(conn *connection) {
	session.connections[conn] = true
	for _, dataSource := range session.dataSources {
		dataSource.registerConnection <- conn
	}
}

func (session Session) unregisterConnection(conn *connection) {
	for _, dataSource := range session.dataSources {
		dataSource.unregisterConnection <- conn
	}
}

type Persistor struct {
	connection redis.Conn
	incomingTimedEvents <-chan *TimedEvent
}

func (persistor *Persistor) persistTimedEvent(timedEvent *TimedEvent) {
	marshalledTimedEvent, _ := json.Marshal(timedEvent.Data)
	_, err := persistor.connection.Do("ZADD", "events/" + timedEvent.ID,
		timedEvent.Time.UTC().Unix(), marshalledTimedEvent)
	if err != nil {
		panic(err)
	}
}

type TimedEvent struct {
	ID string `json:"datasource"`
	WsType string `json:"type"`
	Time time.Time   `json:"time"`
	Data map[string]interface{} `json:"data"`
	Status string `json:"status"`
}

func (timedEvent *TimedEvent) Serialize() ([]byte) {
	timedEventString, err := json.Marshal(timedEvent)
	if err != nil {
		fmt.Println("error encoding timedEvent")
	}
	return timedEventString;
}

type DataSource struct {
	ID, Name  string
	Webhooks []string

	propagateTimedEvent chan TimedEvent

	registerPersistor chan *Persistor
	unregisterPersistor chan *Persistor
	persistors map[*Persistor]bool

	registerConnection chan *connection
	unregisterConnection chan *connection
	connections map[*connection]bool
}

type connection struct {
	ws *websocket.Conn

	send chan []byte
}

func (conn *connection) writer() {
	for message := range conn.send {
		err := conn.ws.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			break
		}
	}
	conn.ws.Close()
}

func (c *connection) nullReader() {
	for {
		_, _, err := c.ws.ReadMessage()
		if err != nil {
			break
		}
	}
	c.ws.Close()
}

func resetHandler(_ http.ResponseWriter, request *http.Request) {
	timedEvent := new(TimedEvent)
	timedEvent.WsType = "reload"
	serializedTimedEvent := []byte(timedEvent.Serialize())

	for connection := range session.connections {
		connection.send <- serializedTimedEvent
		request.Body.Close()
	}
}

func wsHandler(writer http.ResponseWriter, request *http.Request) {
	ws, err := websocket.Upgrade(writer, request, nil, 1024, 1024)
	if _, ok := err.(websocket.HandshakeError); ok {
		http.Error(writer, "Not a websocket handshake", 400)
		return
	} else if err != nil {
		return
	}
	conn := &connection{send: make(chan []byte, 256), ws: ws}
	session.registerConnection(conn)
	go conn.writer()
	defer func() {
		delete(session.connections, conn)
		session.unregisterConnection(conn)
		close(conn.send)
	} ()
	conn.nullReader()
}

func (dataSource *DataSource) run() {
	for {
		select {
		case persistor := <-dataSource.registerPersistor:
			dataSource.persistors[persistor] = true
		case persistor := <-dataSource.unregisterPersistor:
			delete(dataSource.persistors, persistor)
		case connection := <-dataSource.registerConnection:
			fmt.Println("registering connection")
			dataSource.connections[connection] = true
		case connection := <- dataSource.unregisterConnection:
			fmt.Println("unregistering connection")
			delete(dataSource.connections, connection)
		case timedEvent := <-dataSource.propagateTimedEvent:
			for conn, _ := range session.connections {
				conn.send <- []byte(timedEvent.Serialize())
			}
			for persistor, _ := range dataSource.persistors {
				persistor.persistTimedEvent(&timedEvent)
			}
		}
	}
}


func (dataSource *DataSource) RegisterWebhookHandlers(router *http.ServeMux) {
	for _, webhook := range dataSource.Webhooks {
		router.HandleFunc("/" + webhook, func(_ http.ResponseWriter, request *http.Request) {
				fmt.Println(webhook)
				dataSource.propagateTimedEvent <- dataSource.NewTimedEventFromRequest(request.Body)
				request.Body.Close()
			})
	}
}

func (dataSource *DataSource) NewTimedEventFromRequest(body io.Reader) TimedEvent {
	var timedEvent TimedEvent
	decoder := json.NewDecoder(body)
	err := decoder.Decode(&timedEvent)
	if err != nil {
		fmt.Println(err)
		panic(err)
	}
	timedEvent.WsType = "update"
	timedEvent.ID = dataSource.ID
	return timedEvent
}

func DataSourcesFromConfigurationFiles() []*DataSource {
	//TODO (bbss) refactor magic string
	return dataSourcesGetter(directoryIndexer("web/sources/*.yaml"))
}

func directoryIndexer(directory string) []string {
	files, _ := filepath.Glob(directory)
	return files
}

func dataSourcesGetter(paths []string) []*DataSource {
	dataSources := make([]*DataSource, len(paths))
	for i, v := range paths {
		dataSources[i] = newDataSourceFromPath(v)
	}
	err := allWebhooksUnique(dataSources)
	if err != nil {
		panic(err)
	}
	return dataSources
}

func newDataSourceFromPath(path string) *DataSource {
	file, _ := yaml.ReadFile(path)
	fName := filepath.Base(path)
	extName := filepath.Ext(path)
	bName := fName[:len(fName)-len(extName)]
	id := bName

	name, _ := file.Get("name")
	length, _  := file.Count("webhooks")
	if length < 0 {
		length = 0
	}
	webhooks := make([]string, length)
	for i := 0 ; i < length ; i++  {
		it := strconv.Itoa(i)
		webhooks[i], _ = file.Get("webhooks[" + it + "]")
	}
	dataSource := new(DataSource)
	dataSource.ID = id
	dataSource.Name = name
	dataSource.Webhooks = webhooks
	dataSource.propagateTimedEvent = make(chan TimedEvent)
	dataSource.registerPersistor = make(chan *Persistor)
	dataSource.registerConnection = make(chan *connection)
	dataSource.unregisterConnection = make(chan *connection)
	dataSource.persistors = make(map[*Persistor]bool)
	dataSource.connections = make(map[*connection]bool)
	return dataSource
}

func allWebhooksUnique(dataSources []*DataSource) error {
	webhooks := make(map[string]bool)

	for _, dataSource := range dataSources {
		for _, val := range dataSource.Webhooks {
			_, alreadyInWebhooks := webhooks[val]
			if alreadyInWebhooks == true {
				return errors.New("webhook " + val + " already registered")
			}
			//set a value to store webhook in map
			webhooks[val] = true
		}
	}

	return nil
}

func storeDataSourcesInRedis(dataSources []*DataSource, connection redis.Conn) {
	for _, datasource := range dataSources {
		connection.Do("HSET", "datasource/" + datasource.ID, "Name",  datasource.Name)
		for _, webhook := range datasource.Webhooks {
			connection.Do("SADD", "datasource/" + datasource.ID + "/webhooks", webhook)
		}
	}
}
