package dashy_server

import( 
	// "fmt"
	"testing"
	"github.com/bbss/dashy/bin/dashy/collector"
	. "github.com/smartystreets/goconvey/convey"
	"net/http/httptest"
	"net/http"
	"net/url"
	"time"
	"encoding/json"
)

func TestListenForRequests(t *testing.T) {
	Convey("Server maps datasources to incoming POST requests through its webhooks", t, func () {
		dataSources := []*datasource_configurator.DataSource{
			&datasource_configurator.DataSource{"some-id", "some name", []string{"some-webhook"}}}

		bogusData := url.Values{"some-data": {"aya"}}

		testServer := httptest.NewServer(ListenForRequests(dataSources))
		
		defer testServer.Close()

		existingWebhookResponse, _ := http.PostForm(testServer.URL + "/some-webhook", bogusData)
		nonExistentWebhookResponse, _ := http.PostForm(testServer.URL + "/some-other-webhook", bogusData)
		
		defer existingWebhookResponse.Body.Close()
		defer nonExistentWebhookResponse.Body.Close()
		
		So(existingWebhookResponse.StatusCode, ShouldEqual, http.StatusOK)
		So(nonExistentWebhookResponse.StatusCode, ShouldEqual, http.StatusNotFound)

	})

}

func TestNewTimedEventsFromJsonData(t *testing.T) {
	Convey("Timed Events should be created from correct format JSON data", t, func() {
		var rightNow = time.Now().UTC().Format(time.RFC3339Nano)
		var rightNowString = string(rightNow)
		var jsonData = []byte(`[
			{"eventType" : "commit", "time" : "` + rightNowString + `",
			 "data" : {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}}
			]`)
		var jsonDataDataField = []byte(`
			 {"some-field" : "some-value",
					   "some-other-field" : "some-other-value"}
			`)
		var dat map[string]string
		if err := json.Unmarshal(jsonDataDataField, &dat); err !=nil {
			panic(err)
		}

		timedEvents := newTimedEventsFromJsonData(jsonData)
		So(timedEvents[0].Time.UTC().Format(time.RFC3339Nano), ShouldEqual, rightNow)
		So(timedEvents[0].EventType, ShouldEqual, "commit")
		So(timedEvents[0].Data, ShouldResemble, dat)
	})
}

