package dashy 

import(
	"fmt"
	"testing"
	. "github.com/smartystreets/goconvey/convey"
	"github.com/garyburd/redigo/redis"
)

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

func TestDataSourcesGetter(t *testing.T) {
	var dataSources []*DataSource
	dataSources = dataSourcesGetter(directoryIndexer("sources/*.yaml"))
	Convey("Will create multiple dataSources", t, func() {
		So(len(dataSources), ShouldEqual, 2)
	})
}

func TestStoreDataSource(t *testing.T) {
	var dataSources []*DataSource
	Convey("Will store datasources in redis", t, func() {
		idString := "some-id"
		dataSources = []*DataSource{&DataSource{idString, "Pretty Name", []string{"test-webhook"}}}
		storeDataSourcesInRedis(dataSources)
		connection, _ := redis.Dial("tcp", ":6379")
		defer connection.Close()
		//checking if the fields have been set correctly
		name, _ := redis.String(connection.Do("HGET", "datasource/" + idString, "Name"))
		So(name, ShouldEqual, "Pretty Name")
		
		Convey("and should do so for multiple dataSources", func() {
		var otherIdString = "some-other-id"
		dataSources = []*DataSource{&DataSource{idString, "Pretty Name", []string{"test-webhook"}}, 
												{otherIdString, "Pretty Name", []string{"test-other-webhook"}}}	
		storeDataSourcesInRedis(dataSources)
		
		connection, _ := redis.Dial("tcp", ":6379")
		defer connection.Close()
		webhooks, _ := redis.Strings(connection.Do("SMEMBERS", "datasource/" + otherIdString + "/webhooks"))
		So(webhooks, ShouldResemble, []string{"test-other-webhook"})
		})
	})
}

func TestUniqueWebhooks(t *testing.T) {
	Convey("Two files with duplicate webhooks should throw an error", t, 	func() {
		So(func() { dataSourcesGetter(directoryIndexer("sourcesWithDuplicateWebhooks/*.yaml")) },
			ShouldPanic)
	})
}
