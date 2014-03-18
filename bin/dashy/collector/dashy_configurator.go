package datasource_configurator

import (
	"errors"
	"path/filepath"
	"github.com/kylelemons/go-gypsy/yaml"
	"strconv"
	"github.com/garyburd/redigo/redis"
)

type DataSource struct {
	ID, Name  string
	Webhooks []string
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
