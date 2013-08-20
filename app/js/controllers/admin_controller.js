angular.module('Dashboard.Admin', [])

.controller('AddCtrl', ['$scope', '$http', 'Admin', 'Sources',
    function($scope, $http, Admin, Sources) {
        // Define widget & content
        // >>>>>>>>>>>>>>>>>>>>>>>
        $scope.widget = {config: {}, content: [],layout: {}};
        $scope.content = {"type": "data"};
        $scope.content.options = {};

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

        // Content Options
        // >>>>>>>>>>>>>>>>
        $scope.contentAdd = function(content) {
            $scope.widget.content.push({
                "type": content.type,
                "refresh": content.refresh,
                "template": content.template,
                "options": content.options
            });
            $scope.content = {"type": "data"}
            $scope.content.options = {};
        }

        // $scope.template1Remove = function(index) {
        //     $scope.template1.splice(index, 1);
        // }

        // Add widget function
        // >>>>>>>>>>>>>>>>>>>
        $scope.addWidget = function(widget){
            // Check Source Value
            // >>>>>>>>>>>>>>>>>>
            if(widget.config.source == undefined) {
                $scope.widget.config.source = " ";
            }

            // POST to Database
            // >>>>>>>>>>>>>>>>
            console.log($scope.widget)
            Admin.addWidget($scope.widget);
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