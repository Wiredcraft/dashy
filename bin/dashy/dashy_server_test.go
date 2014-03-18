package dashy_server

import( 
	// "fmt"
	"testing"
	"github.com/bbss/dashy/bin/dashy/collector"
	. "github.com/smartystreets/goconvey/convey"
	"net/http/httptest"
	"net/http"
	"time"
	"encoding/json"
	"bytes"
)

func TestListenForRequests(t *testing.T) {
	Convey("Server maps datasources to incoming POST requests through its webhooks", t, func () {
		dataSources := []*datasource_configurator.DataSource{
			&datasource_configurator.DataSource{"some-id", "some name", []string{"some-webhook"}}}
		var rightNow = string(time.Now().UTC().Format(time.RFC3339Nano))


		testServer := httptest.NewServer(ListenForRequests(dataSources))
		
		defer testServer.Close()

		existingWebhookResponse, _ := http.Post(testServer.URL + "/some-webhook",  "application/json", bytes.NewBufferString(`{"eventType" : "commit", "time" : "` + rightNow + `",
			 "data" : {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}}
			`))
		nonExistentWebhookResponse, _ := http.Post(testServer.URL + "/some-other-webhook", "application/json", bytes.NewBufferString(`{"eventType" : "commit", "time" : "` + rightNow + `",
			 "data" : {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}}
			`))
		
		defer existingWebhookResponse.Body.Close()
		defer nonExistentWebhookResponse.Body.Close()
		
		So(existingWebhookResponse.StatusCode, ShouldEqual, http.StatusOK)
		So(nonExistentWebhookResponse.StatusCode, ShouldEqual, http.StatusNotFound)
	})

}	

func TestNewTimedEventFromRequest(t *testing.T) {
	Convey("Timed Events should be created from correct format JSON data", t, func() {
		var rightNow = time.Now().UTC().Format(time.RFC3339Nano)
		var rightNowString = string(rightNow)
		var jsonData = bytes.NewBufferString(`
			{"eventType" : "commit", "time" : "` + rightNowString + `",
			 "data" : {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}}
			`)
		var jsonDataDataField = []byte(`
			 {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}
			`)
		var dat map[string]string
		if err := json.Unmarshal(jsonDataDataField, &dat); err !=nil {
			panic(err)
		}

		timedEvent := newTimedEventFromRequest(jsonData)
		So(timedEvent.Time.UTC().Format(time.RFC3339Nano), ShouldEqual, rightNow)
		So(timedEvent.EventType, ShouldEqual, "commit")
		So(timedEvent.Data, ShouldResemble, dat)
	})
}



