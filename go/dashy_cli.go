package main

import (
	"fmt"
	"path/filepath"
	//"flag"
	"github.com/kylelemons/go-gypsy/yaml"
	"strconv"
)
func main() {
}

func DataSourcesGetter(paths []string) []*DataSource {
	dataSources := make([]*DataSource, len(paths))
	for i, v := range paths {
		dataSources[i] = NewDataSourceFromPath(v)
	}

	return dataSources
}

func DirectoryIndexer(directory string) []string {
	files, _ := filepath.Glob(directory) 
	return files
}

type DataSource struct {
	ID, Name  string
	Webhooks []string
}

func NewDataSourceFromPath(path string) *DataSource {
	result, _ := yaml.ReadFile(path)
	id, _ := result.Get("id")
	name, _ := result.Get("name")
	length, _  := result.Count("webhooks")
	fmt.Println(name)
	fmt.Println(length)
	if length < 0 {
		length = 0
	}
	webhooks := make([]string, length)
	for i := 0 ; i < length ; i++  {
		it := strconv.Itoa(i)
		webhooks[i], _ = result.Get("webhooks[" + it + "]")	
	}
	dataSource := new(DataSource)
	dataSource.ID = id
	dataSource.Name = name
	dataSource.Webhooks = webhooks
	return dataSource
}
