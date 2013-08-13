angular.module('Dashboard.Admin', [])

.controller('AddCtrl', ['$scope', '$http', 'Admin', 'Sources',
    function($scope, $http, Admin, Sources) {
        $scope.randomID = true; // CouchDB will provide an ID if true

        // Get list of useable datasources
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Sources.getSources().then(function(data) {
            $scope.sources = data;
        });

        // Get templates in /js/config/config.json
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Sources.getTemplates().then(function(data) {
            $scope.dbWidgets = data[0];
        });



        // Template Options
        // >>>>>>>>>>>>>>>>
        $scope.template1 = [];
        $scope.template2 = [];

        $scope.template1Add = function(template1) {
            $scope.template1.push({"key": template1.key, "value": template1.value});
            template1.key = "", template1.value = "";
        }
        $scope.template1Remove = function(index) {
            $scope.template1.splice(index, 1);
        }

        $scope.template2Add = function(template2) {
            $scope.template2.push({"key": template2.key, "value": template2.value});
            template2.key = "", template2.value = "";
        }
        $scope.template2Remove = function(index) {
            $scope.template2.splice(index, 1);
        }

        // Add widget function
        // >>>>>>>>>>>>>>>>>>>
        $scope.widget = {_id:"", config: {}, content: {},layout: {}};
        $scope.realWidget;
        $scope.addWidget = function(widget, options){
            var temp1 = options.template1;
            var temp2 = options.template2;
            var dir1 = {};
            var dir2 = {};

            // Construct Widget
            // >>>>>>>>>>>>>>>>
            $scope.realWidget = {
                "config": {
                    "refresh": widget.config.refresh,
                    "source": widget.config.source,
                },
                "content": {
                    "title": widget.content.title,
                    "templates": {}
                },
                "layout": {
                    "data-row": widget.layout["data-row"],
                    "data-col": widget.layout["data-col"],
                    "data-sizex": widget.layout["data-sizex"],
                    "data-sizey": widget.layout["data-sizey"]
                }
            }

            // Add ID if not random
            // >>>>>>>>>>>>>>>>>>>>
            if ($scope.randomID === false) {
                $scope.realWidget._id = widget._id;
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
            $scope.realWidget.content.templates[temp1] = dir1;
            
            // If only 1 template, don't add 2nd as undefined
            if (temp2 != undefined || temp2 != null ) {
                for(i = 0; i < $scope.template2.length; i++) {
                    dir2[$scope.template2[i].key] = $scope.template2[i].value;
                };
                $scope.realWidget.content.templates[temp2] = dir2;
            }

            console.log($scope.realWidget);

            // POST to Database
            // >>>>>>>>>>>>>>>>
            Admin.addWidget($scope.realWidget);
        };

    }
])

.controller('UpdateCtrl', ['$scope', '$http', '$location', 'Admin', 'Sources', 'Widgets',
    function($scope, $http, $location, Admin, Sources, Widgets) {
        $scope.updateSource = false;
        $scope.updateTemplates = false;

        // Get widget ID
        // >>>>>>>>>>>>>
        var id = $location.hash();
        var thisId = id;

        // Get the widget to edit
        // >>>>>>>>>>>>>>>>>>>>>>
        Widgets.getWidgetById(thisId).then(function(data) {
            $scope.widget = data;
            // $scope.widget.config.source = data.config.source;
            console.log(data.config.source);
            $scope.thisTitle = data.content.title;
        });

        // Get list of useable datasources
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Sources.getSources().then(function(data) {
            $scope.sources = data;
        });

        // Get templates in /js/config/config.json
        // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Sources.getTemplates().then(function(data) {
            $scope.dbWidgets = data[0];
        });

        // Template Options
        // >>>>>>>>>>>>>>>>
        $scope.template1 = [];
        $scope.template2 = [];

        $scope.template1Add = function(template1) {
            $scope.template1.push({"key": template1.key, "value": template1.value});
            template1.key = "", template1.value = "";
        }
        $scope.template1Remove = function(index) {
            $scope.template1.splice(index, 1);
        }

        $scope.template2Add = function(template2) {
            $scope.template2.push({"key": template2.key, "value": template2.value});
            template2.key = "", template2.value = "";
        }
        $scope.template2Remove = function(index) {
            $scope.template2.splice(index, 1);
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