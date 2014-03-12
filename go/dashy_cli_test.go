package main

import(
	"fmt"
	"testing"
	. "github.com/smartystreets/goconvey/convey"
)

//retrieves path to yaml files from sources directory
func ExampleDirectoryIndexer() {
	fmt.Println(DirectoryIndexer("sources/*"))
	//Output:
	//[sources/CPU.yaml sources/test.yaml]
}

func TestNewDataSourceFromPath(t *testing.T) {
	var dataSource *DataSource

	Convey("Given a path string to a config yaml file creates a new dataSource", t, func() {
		dataSource = NewDataSourceFromPath("sources/CPU.yaml")
		So(dataSource, ShouldNotBeNil)
	})
}

func TestDataSourcesGetter(t *testing.T) {
	var dataSources []*DataSource
	dataSources = DataSourcesGetter(DirectoryIndexer("sources/*"))
	Convey("Will create multiple dataSources", t, func() {
		So(len(dataSources), ShouldEqual, 2)
	})
}
