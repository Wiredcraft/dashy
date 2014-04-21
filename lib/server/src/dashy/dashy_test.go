package main

import(
	"testing"
	"fmt"
	. "github.com/smartystreets/goconvey/convey"
	"time"
	"encoding/json"
	"bytes"
	"github.com/garyburd/redigo/redis"
	"net/http"
	"net/http/httptest"
)

var rightNow = time.Now().UTC()
var rightNowString = rightNow.Format(time.RFC3339Nano)
var dataSource = DataSource{ID: "some-id", Name: "some pretty name",
	Webhooks: []string{"some-webhook"}, propagateTimedEvent: make(chan TimedEvent),
	registerPersistor: make(chan *Persistor), persistors: make(map[*Persistor]bool)}


//retrieves path to yaml files from sources directory
func ExampleDirectoryIndexer() {
	fmt.Println(directoryIndexer("sources/*.yaml"))
	//Output:
	//[sources/CPU.yaml sources/test.yaml]
}

func TestNewDataSourceFromPath(t *testing.T) {
	var dataSource *DataSource

	Convey("Given a path string to a config yaml file creates a new dataSource", t, func() {
			dataSource = newDataSourceFromPath("sources/CPU.yaml")
			So(dataSource, ShouldNotBeNil)
		})
}


func TestUniqueWebhooks(t *testing.T) {
	Convey("Two files with duplicate webhooks should throw an error", t, 	func() {
			So(func() { dataSourcesGetter(directoryIndexer("sourcesWithDuplicateWebhooks/*.yaml")) },
				ShouldPanic)
		})
}

func TestDataSourcesGetter(t *testing.T) {
	var dataSources []*DataSource
	dataSources = dataSourcesGetter(directoryIndexer("sources/*.yaml"))
	Convey("Will create multiple dataSources", t, func() {
			So(len(dataSources), ShouldEqual, 2)
		})
}

func TestNewTimedEventFromRequest(t *testing.T) {
	var timedEventBody = bytes.NewBufferString(`
				{"time" : "` + rightNowString + `",
				 "data" : {"some-field" : "some-value",
						   "some-other-field" : 2}}
				`)

	Convey("Timed Events should be created from correct format JSON data", t, func() {
			var jsonDataDataField = []byte(`
			 {"some-field" : "some-value",
					   "some-other-field" : 2}
			`)
			var dat map[string]interface{}
			if err := json.Unmarshal(jsonDataDataField, &dat); err !=nil {
				panic(err)
			}

			timedEvent := dataSource.NewTimedEventFromRequest(timedEventBody)
			So(timedEvent.Time.UTC().Format(time.RFC3339Nano), ShouldEqual, rightNowString)
			So(timedEvent.Data, ShouldResemble, dat)
		})
}

func TestStoreDataSource(t *testing.T) {
	var dataSources []*DataSource

	connection, _ := redis.Dial("tcp", ":6379")
	connection.Do("FLUSHALL")
	defer connection.Close()

	Convey("Will store datasources in redis", t, func() {
			idString := "some-id"
			dataSources = []*DataSource{&dataSource}
			storeDataSourcesInRedis(dataSources, connection)
			//checking if the fields have been set correctly
			name, _ := redis.String(connection.Do("HGET", "datasource/" + idString, "Name"))
			So(name, ShouldEqual, "some pretty name")

			Convey("and should do so for multiple dataSources", func() {
					var otherIdString = "some-other-id"
					dataSources = []*DataSource{&DataSource{ID: idString, Name: "Pretty Name",
					Webhooks: []string{"test-webhook"}, propagateTimedEvent: make(chan TimedEvent)},
					&DataSource	{ID: otherIdString, Name: "Pretty Name", Webhooks: []string{"test-other-webhook"},
					propagateTimedEvent: make(chan TimedEvent)}}

					storeDataSourcesInRedis(dataSources, connection)
					webhooks, _ := redis.Strings(connection.Do("SMEMBERS", "datasource/" + otherIdString + "/webhooks"))
					So(webhooks, ShouldResemble, []string{"test-other-webhook"})
				})
		})
}


func TestDataSourceListeners(t *testing.T) {
	var timedEventBody = bytes.NewBufferString(`
				{"time" : "` + rightNowString + `",
				 "data" : {"some-field" : "some-value",
						   "some-other-field" : 2}}
				`)
	connection, _ := redis.Dial("tcp", ":6379")
	connection.Do("FLUSHALL")
	defer connection.Close()

	Convey("Datasources should convert postrequests to timedEvents", t, func() {
			go dataSource.run()
			router := http.NewServeMux()
			dataSource.RegisterWebhookHandlers(router)
			persistor := Persistor{connection: connection, incomingTimedEvents: make(<-chan *TimedEvent)}


			dataSource.registerPersistor <- &persistor
			fmt.Println("registered persistor to datasource")


			server := httptest.NewServer(router)
			defer server.Close()

			connection, _ := redis.Dial("tcp", ":6379")
			connection.Do("FLUSHALL")
			defer connection.Close()

			http.Post(server.URL + "/some-webhook", "application/json", timedEventBody)
			redisResult, err := redis.Strings(connection.Do("ZRANGEBYSCORE", "events/" + dataSource.ID, 0, "+inf"))
			if err != nil {
				panic(err)
			}

			So(redisResult[0], ShouldResemble, `{"some-field":"some-value","some-other-field":2}`)

	})
}
