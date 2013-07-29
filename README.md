##Install these first!
NPM & Grunt must be installed, Ruby must be installed for gems.

Compass -	`gem update && gem install compass`


##Start it up
1. Clone the repo
2. `cd` into repo
3. `npm install`
4. `npm start`
5. Go to `http://localhost:4000/`
6. Optional: Open a new terminal window and run grunt when working on css

##Terms
`widget` - a tile on the dashboard.

`visualization` - visual parts which make up a widget, not including the title/heading.

##API

`/widget` - returns list of widgets

`/sources` - returns list of sources (must be manually set up, settings.js)

`/:database` (eg. `/githubrepos`) - returns data set of datasource using the view that is created when adding to the /sources

- /widget
	- GET - `/widget`
	- POST - `/widget`
	- PUT - `/widget/:id`
	- DELETE - `/widget/:id`
- /sources
	- GET - `/sources`
- /:database
	- GET - `/:database`
	- POST - `/:database`
	- PUT - `/:database/:id`
	- DELETE - `/:database/:id`
	
###Settings
In order to add a new datasource to the widget, you must first define it in the `settings.js` file. Below is an example of the database `githubrepos` being defined inside `settings.js`

        githubrepos: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.date && doc.amount) {
                            emit(doc._rev,{
                                'date' : doc.date,
                                'amount' : doc.amount
                            });
                        }
                    }
                }
            },
            // for basic validate at router side
            validate : function (oData) {
                if (oData && oData.name && oData.status) {
                    return false;
                } else {
                    return true;
                }
            }
        }
        
Now `http://apiUrl.com/githubrepos` will retrun an array of objects. Each one looking similar to the object below.
        
	{
		id: "5520d3749727a68339b7eac5ff02b955",
		key: "1-02ae2b48cd8ec63984f323ec0846c086",
		value: {
			date: "28-Mar-12",
			amount: 617.62
		}
	}
        

It is recommended that this be the first thing you do as this will create the CouchDB database for you, and also add the design/view defined in the settings. Restarting `npm start` will be required for changes to take effect.

`Needs verification` - To change the design/view at a later time you must manually add it into CouchDB yourself.


##Files
`main_controller.js` - main controller for the app, calls for data and passes it to directives and more...

`charts_directives.js` - directives for each visualization.

`tags_directives.js` - directives for the widget and widgets html tags, responsible for placing gridster and its elements (the widgets) onto the page.

`formatters.js` - Contains formatters that can be used by directives to reformat data. As opposed to re-writing the same formatters in multiple widgets.

`filters.js` - Contains fitlters that are always on for a visualization. These are applied in the `/templates/someTemplate.html`.

`widgets_factory.js` - Service to handle api calls for that delicious data.

`routes.js` - the route provider for the app.

`/partials/` - folder containing html files that are used by `tags_directives` and `ng-view`.

`/templates/` - folder containing html templates for visualizations. Html files are named identically to the name of their directive. For example the gauge visualization's directive is called gauge, therefore its html template is called `gauge.html`

`index.html` - index page, all `<script>` and `<link>` tags are here. Contains `<ng-view>`


##Install Script
Is now very out-dated and will be updated soon. Along with this section of documentation.

##CouchDB
Names of Databases in use:
 
 - `widgets` - Widget configuration documents
 - `sources` - Documents containing source information
 - `githubrepos` - Data set
 - `builds` - Data set
 - `commits` - Data set

##Replication
Should you need to replicate a database from another machine use the following code

`curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://SOURCE-URL:5984/DATABASE_TO_REPLICATE", "target": "db_to_replicate_into", "create_target":true} '`

create target creates the database if you have not yet created it.