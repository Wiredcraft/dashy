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
	"net/http"
)

func main() {
	//create datasources

	//create http server

	//create listeners for webhooks

	//create listeners for websocket connections
}

type DataSource struct {
	ID, Name  string
	Webhooks []string

	propagateTimedEvent chan TimedEvent

	registerPersistor chan *Persistor
	unregisterPersistor chan *Persistor
	persistors map[*Persistor]bool
}

func (dataSource *DataSource) run() {
	for {
		select {
		case persistor := <-dataSource.registerPersistor:
			dataSource.persistors[persistor] = true
		case persistor := <-dataSource.unregisterPersistor:
			delete(dataSource.persistors, persistor)
		case timedEvent := <-dataSource.propagateTimedEvent:
			for persistor, _ := range dataSource.persistors {
				persistor.persistTimedEvent(&timedEvent)
			}
		}
	}
}


func (dataSource *DataSource) RegisterWebhookHandlers(router *http.ServeMux) {
	for _, webhook := range dataSource.Webhooks {
		router.HandleFunc("/" + webhook, func(_ http.ResponseWriter, request *http.Request) {
					dataSource.propagateTimedEvent <- dataSource.NewTimedEventFromRequest(request.Body)
			})
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
	ID string `json: "id"`
	Time time.Time   `json:"time"`
	Data map[string]interface{} `json: "data"`
}

func (dataSource *DataSource) NewTimedEventFromRequest(body io.Reader) TimedEvent {
	var timedEvent TimedEvent
	decoder := json.NewDecoder(body)
	err := decoder.Decode(&timedEvent)
	if err != nil {
		panic(err)
	}
	timedEvent.ID = dataSource.ID;
	return timedEvent
}

func DataSourcesFromConfigurationFiles() []*DataSource {
	return dataSourcesGetter(directoryIndexer("sources/*.yaml"))
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
