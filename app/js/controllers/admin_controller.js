angular.module('Dashboard.Admin', [])

.controller('AddCtrl', ['$scope', '$http', 'Admin', 'Sources',
    function($scope, $http, Admin, Sources) {

        console.log(window);

        // List of possible templates
        // >>>>>>>>>>>>>>>>>>>>>>>>>>
        $scope.dbWidgets = {
            "linechart": {
                "points": 0
            },
            "delta": {},
            "gauge": {
                "min": 0,
                "max": 0,
            },
            "sum": {
                "append": "",
                "prepend": "",
                "subtitle": ""
            },
            "list": {
                "limit": 0
            },
            "picture": {},
            "gauge": {},
            "countdown": {
                "startdate": 0,
                "enddate": 0
            },
            "announcement": {
                "announcement": "",
                "subtitle": ""
            }
        }

        // Get list of useable datasources
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        $scope.sources = Sources.getSources();

        // Template Options
        // >>>>>>>>>>>>>>>>
        $scope.template1 = [];
        $scope.template2 = [];

        $scope.template1Option = function(template1) {
            $scope.template1.push({"key": template1.key, "value": template1.value});
            console.log($scope.template1);
            template1.key = "", template1.value = "";
        }

        $scope.template2Option = function(template2) {
            $scope.template2.push({"key": template2.key, "value": template2.value});
            console.log($scope.template2)
            template2.key = "", template2.value = "";
        }

        // Add widget function
        // >>>>>>>>>>>>>>>>>>>
        $scope.widget = {};
        $scope.realWidget;
        $scope.addWidget = function(widget, options){
            var temp1 = options.template1;
            var temp2 = options.template2;
            var dir1 = {};
            var dir2 = {};

            // Construct Widget
            // >>>>>>>>>>>>>>>>
            $scope.realWidget = {
                "_id" : widget._id,
                "config": {
                    "refresh": widget.config.refresh,
                    "source": widget.config.source,
                },
                "content": {
                    "title": widget.content.title,
                    "templates": {}
                },
                "layout": {
                    "data-row": widget.layout.data_row,
                    "data-col": widget.layout.data_col,
                    "data-sizex": widget.layout.data_sizex,
                    "data-sizey": widget.layout.data_sizey
                }
            }

            // Check Source Value
            // >>>>>>>>>>>>>>>>>>
            if(widget.config.source == undefined) {
                $scope.realWidget.config.source = " ";
            }

            // Prepare Template Options
            // >>>>>>>>>>>>>>>>>>>>>>>>
            for(i = 0; i < $scope.template1.length; i++) {
                dir1[$scope.template1[i].key] = $scope.template1[i].value;
            };

            for(i = 0; i < $scope.template2.length; i++) {
                dir2[$scope.template2[i].key] = $scope.template2[i].value;
            };

            $scope.realWidget.content.templates[temp1] = dir1;
            $scope.realWidget.content.templates[temp2] = dir2;

            console.log($scope.realWidget);

            // POST to Database
            // >>>>>>>>>>>>>>>>
            Admin.addWidget($scope.realWidget);

        };

    }
])

.controller('UpdateCtrl', ['$scope', '$http', '$location', 'Admin', 'Sources', 'Widgets',
    function($scope, $http, $location, Admin, Sources, Widgets) {

        // List of possible templates
        // >>>>>>>>>>>>>>>>>>>>>>>>>>
        $scope.dbWidgets = {
            "linechart": {
                "points": 0
            },
            "delta": {},
            "gauge": {
                "min": 0,
                "max": 0,
            },
            "sum": {
                "append": "",
                "prepend": "",
                "subtitle": ""
            },
            "list": {
                "limit": 0
            },
            "picture": {},
            "gauge": {},
            "countdown": {
                "startdate": 0,
                "enddate": 0
            },
            "announcement": {
                "announcement": "",
                "subtitle": ""
            }
        }

        // Get list of useable datasources
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        $scope.sources = Sources.getSources();

        // Get widget ID
        // >>>>>>>>>>>>>
        var id = $location.hash();
        $scope.thisId = id;

        // Get the widget to edit
        // >>>>>>>>>>>>>>>>>>>>>>
        Widgets.getWidgetById($scope.thisId).then(function(data) {
            $scope.widget = data;
        });


        // Template Options
        // >>>>>>>>>>>>>>>>
        $scope.template1 = [];
        $scope.template2 = [];

        $scope.template1Option = function(template1) {
            $scope.template1.push({"key": template1.key, "value": template1.value});
            template1.key = "", template1.value = "";
        }

        $scope.template2Option = function(template2) {
            $scope.template2.push({"key": template2.key, "value": template2.value});
            template2.key = "", template2.value = "";
        }


        // Update Function
        // >>>>>>>>>>>>>>>
        $scope.updateWidget = function(widget, options) {
            var dir1 = {};
            var dir2 = {};

            // Check Source Value
            // >>>>>>>>>>>>>>>>>>
            if(widget.config.source == undefined) {
                widget.config.source = " ";
            }

            // Prepare Template Options
            // >>>>>>>>>>>>>>>>>>>>>>>>
            if ($scope.template1.length > 0) {
                for(i = 0; i < $scope.template1.length; i++) {
                    dir1[$scope.template1[i].key] = $scope.template1[i].value;
                };                
            }

            if ($scope.template2.length > 0) {
                for(i = 0; i < $scope.template2.length; i++) {
                    dir2[$scope.template2[i].key] = $scope.template2[i].value;
                };                
            }

            // Get current template names
            // >>>>>>>>>>>>>>>>>>>>>>>>>>
            var currentTemplates = Object.keys(widget.content.templates);

            // Replace templates if new ones chosen
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            if (options !== undefined) {
                if (options.template1 !== undefined && options.template1 !== 'undefined') {
                    delete widget.content.templates[currentTemplates[0]];
                    widget.content.templates[options.template1] = dir1;
                }
                if (options.template2 !== undefined && options.template2 !== 'undefined') {
                    delete widget.content.templates[currentTemplates[1]];
                    widget.content.templates[options.template2] = dir2;
                }
            }

            // Remove the 2nd template if selected
            // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            if (options != undefined && options.remove != undefined && options.remove === true) {
                delete widget.content.templates[currentTemplates[1]];
            }

            // PUT update to db
            // >>>>>>>>>>>>>>>>
            Admin.updateWidget(id, widget);
        };

    }
])