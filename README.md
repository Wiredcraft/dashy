##Install these first!

NodeJS & CouchDB

Dev - Grunt must be installed, Ruby must be installed for the compass gem.
Compass - `gem update && gem install compass`


##Start it up
Read INSTALL.md for latest installation instructions

1. Clone the repo
2. `cd` into repo
3. `npm install`
4. `./install/dashr`
4. `npm start`
5. Go to `http://localhost:4000/`
6. Dev: Open a new terminal window and run grunt when working on css


##Known Bugs + To Do

Can be found in the wiki or [here](https://hackpad.com/Dashy-jjdu6nzpWnk) (hackpad.com)


##API

`/widget` - returns list of widgets

`/widget/:id` - returns a widget by Id

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
	

##Files
*Controllers*

- `main_controller.js` - Main controller, handles getting getting the list of widgets and their data.
- `admin_controller.js` - Admin controller, contains logic for adding and updating widgets.

*Directives*

- `tags_directives.js` - Directives for Widget tags, contains logic for all widgets. (eg. update & delete buttons active functions in the directive controllers)
- `charts_directives.js` - Directives for templates, contains the logic for all templates that can be placed on a widget (eg. linechart, gauge, countdown, etc…)

*Factories*

- `formatters.js` - Formatting functions that can be used by anything, however mainly made for templates in `charts_directives.js` (eg. the "sum" template uses the "Number" formatter, a quick look at the code should give you a good idea of how to utilize this.)
- `widgets_factory.js` - Where the app meets database, all calls for data, sources happen here. Also the functions for adding, updating and deleting widgets are here. There are 3 Sections to it: Widgets, Sources, Admin. Widgets contains functions for getting widget information, either all or by ID. Sources contains a function for getting the source databases.

*Filters*

- `filters.js` - General filters that can be used on templates/partials.

*Utils*

- `utils.js` - not used at the moment, may replace formatters.js in the future.

*Other*

- `routes.js` - handles routing for dashy.

*Partials* - contains html pages / templates that make up the structure of dashy.

*Templates* - contains html templates for widget templates (aka `charts_directives`) that need a template.


## Adding a Widget Template
Steps to successfully add a widget template;

1. Add a directive for your template into `charts_directives.js`.
2. If it needs an html template add it into the `/templates` folder.
3. As of v0.0.2, If you want your directive to be selectable in the admin interface, you must add your directive information (name & possible options) into `$scope.dbWidgets` inside `admin_controllers.js`. A solution for this is being worked on, however if you plan to add your widget via couchDB you can skip this step.

## Adding a Source Database
In order to add a new datasource to the widget, you must first define it in the `settings.js` file. Below is an example of the database `githubrepos` being defined inside `settings.js`

        githubrepos: {
            // couchdb view content
            viewDocContent : {
                all : {
                    map : function(doc) {
                        if (doc.time && doc.data) {
                            emit(doc._rev,{
                                'time' : doc.time,
                                'data' : doc.data
                            });
                        }
                    }
                }
            },
            // for basic validation at router side
            validate : function (oData) {
                if (oData && oData.time && oData.data) {
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
			time: "28-Mar-12",
			data: {
				value: 582.13
			}
		}
	}
        

It is recommended that this be the first thing you do as this will create the CouchDB database for you, and also add the design/view defined in the settings. Restarting `npm start` will be required for changes to take effect.

`Needs verification` - To change the design/view at a later time you must manually add it into CouchDB yourself.


##CouchDB
Names of Databases in use:
 
 - `widgets` - Widget configuration documents
 - `sources` - Documents containing source information
 - And various user-defined datasource databases.

###Replication
Should you need to replicate a database from another machine use the following code

`curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicate -d ' {"source": "http://SOURCE-URL:5984/DATABASE_TO_REPLICATE", "target": "db_to_replicate_into", "create_target":true} '`

create target creates the database if you have not yet created it.
