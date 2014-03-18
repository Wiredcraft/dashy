package dashy_server


import (
	"github.com/bbss/dashy/bin/dashy/collector"
	"net/http"
	"time"
	// "fmt"
	"io"
	"encoding/json"
)

type DashySession struct {
	webhooksDataSourcesMap map[string]*datasource_configurator.DataSource
}


type TimedEvent struct {
	EventType string `json "eventType"`
	Time time.Time   `json:"time"`
	Data map[string]string `json: "data"`
}

func ListenForRequests(dataSources []*datasource_configurator.DataSource) http.Handler {
	//for each datasource
	dashySession := DashySession{make(map[string]*datasource_configurator.DataSource)}
	for _, dataSource := range dataSources {
		for _, webhook := range dataSource.Webhooks {
			//store webhook with its datasource in dashySession
			//and register requesthandler for each Webhooks
			//that sends update to all subscribed listeners of that datasource
			dashySession.webhooksDataSourcesMap["/" + webhook] = dataSource
		}
	}
	
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		if request.Method == "POST" && dashySession.webhooksDataSourcesMap[request.URL.Path] != nil {
			newTimedEventFromRequest(request.Body)
		} else {
			writer.WriteHeader(404)
		}
 	})
}

func newTimedEventFromRequest(body io.Reader) TimedEvent {
		var timedEvent TimedEvent
		decoder := json.NewDecoder(body)
		err := decoder.Decode(&timedEvent)
		if err != nil {
			panic(err)
		}
		return timedEvent
}
