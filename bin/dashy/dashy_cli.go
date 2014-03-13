package dashy

import (
	"path/filepath"
	"github.com/kylelemons/go-gypsy/yaml"
	"strconv"
	"github.com/garyburd/redigo/redis"
)

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

func storeDataSourcesInRedis(dataSources []*DataSource) {
	connection, err := redis.Dial("tcp", ":6379")
	if err != nil {
		panic(err)
	}
	defer connection.Close()
	for _, datasource := range dataSources {
		connection.Do("HSET", "datasource/" + datasource.ID, "Name",  datasource.Name)
		for _, webhook := range datasource.Webhooks {
			connection.Do("SADD", "datasource/" + datasource.ID + "/webhooks", webhook)
		}
	}
}

