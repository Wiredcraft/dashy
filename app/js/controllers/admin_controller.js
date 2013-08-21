angular.module('Dashboard.Admin', ['ui.bootstrap'])

.controller('AddCtrl', ['$scope', '$http', 'Admin', 'Sources', '$location',
    function($scope, $http, Admin, Sources, $location) {
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
            $scope.content = {"type": "data"};
            $scope.content.options = {};
        }
        $scope.contentRemove = function(index) {
            $scope.widget.content.splice(index, 1);
        }

        // Add widget function
        // >>>>>>>>>>>>>>>>>>>
        $scope.addWidget = function(widget){
            // Check Source Value
            // >>>>>>>>>>>>>>>>>>
            if(widget.config.source == undefined || widget.config.source == 'none') {
                $scope.widget.config.source = " ";
            }

            // POST to Database
            // >>>>>>>>>>>>>>>>
            Admin.addWidget($scope.widget).then(function(data) {
                $location.path('');
            });
        };

    }
])

.controller('UpdateCtrl', ['$scope', '$http', '$location', 'Admin', 'Sources', 'Widgets',
    function($scope, $http, $location, Admin, Sources, Widgets) {
        // Define content
        // >>>>>>>>>>>>>>
        $scope.content = {"type": "data"};
        $scope.content.options = {};

        // Get widget ID
        // >>>>>>>>>>>>>
        var id = $location.hash();
        var thisId = id;

        // Get the widget to edit
        // >>>>>>>>>>>>>>>>>>>>>>
        Widgets.getWidgetById(thisId).then(function(data) {
            $scope.widget = data;
            $scope.thisTitle = data.config.title;
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

        // Content Functions
        // >>>>>>>>>>>>>>>>>
        $scope.contentAdd = function(content) {
            $scope.widget.content.push({
                "type": content.type,
                "refresh": content.refresh,
                "template": content.template,
                "options": content.options
            });
            $scope.content = {"type": "data"};
            $scope.content.options = {};
        }
        $scope.contentRemove = function(index) {
            $scope.widget.content.splice(index, 1);
        }

        // Update Function
        // >>>>>>>>>>>>>>>
        $scope.updateWidget = function(widget) {
            // Check Source Value
            // >>>>>>>>>>>>>>>>>>
            if(widget.config.source == undefined || widget.config.source == 'none') {
                widget.config.source = " ";
            }

            // PUT update to db
            // >>>>>>>>>>>>>>>>
            Admin.updateWidget(id, widget).then(function(data) {
                $location.path('');
            });
        };

    }
])

.controller('ModalDemoCtrl', ['$scope', '$http', 'Admin', 'Sources', '$location',
    function($scope, $http, Admin, Sources, $location) {
        $scope.open = function() {
            $scope.shouldBeOpen = true;
        };

        $scope.close = function() {
            $scope.closeMsg = 'I was closed at: ' + new Date();
            $scope.shouldBeOpen = false;
        }

        $scope.items = ['item1', 'item2']

        $scope.opts = {
            backdropFade: true,
            dialogFade: true
        };
    }
])