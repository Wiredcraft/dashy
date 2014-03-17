package dashy_server

import( 
	"fmt"
	"testing"
	"github.com/bbss/dashy/bin/dashy/collector"
	. "github.com/smartystreets/goconvey/convey"
	"net/http/httptest"
	"net/http"
	"net/url"
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


func sshutUpCompiler () {
	fmt.Println("")
}