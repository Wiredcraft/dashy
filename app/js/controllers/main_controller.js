angular.module('Dashboard.Controllers', [])

// Main controller
.controller('MainAppCtrl', ['$scope', 'Widgets', '$rootScope',
    function($scope, Widgets, $rootScope) {

        // get widget's info
        var getWidgetData = function () {
            angular.forEach($scope.widgets, function (widget, index) {
                var source = widget.value.config.source;
                // for countdown widget we dont need couchdb source
                if (angular.isObject(source)) {
                    widget['value']['data'] = source;
                } else {
                    Widgets.getWidgetData(source).then(function(data) {
                        widget['value']['data'] = data;
                        // console.log(widget); // Data available at partials/widgets.html
                    }, function(err) {
                        console.log(err);
                    })
                }
            })
        }      

        // get widget list info
        Widgets.getWidgetList().then(function(data) {
            $scope.widgets = data;
            
            // get widget's info
            getWidgetData();
        }, function(err) {
            console.log(err);
        });

    }
])

.controller('NavCtrl', ['$scope', '$rootScope', '$location',
    function($scope, $rootScope, $location) {
        
        $scope.add = function() {
            $location.path('add');
        }

        // Lock / Unlock draggable
        $scope.lock = function() {
            $rootScope.gridster.disable();
            $rootScope.locked = true;
        };
        $scope.unlock = function() {
            $rootScope.gridster.enable();
            $rootScope.locked = false;
        };

        // Manually refresh widget data.
        // For now refreshes whole page.
        $scope.refresh = function() {
            document.location.reload(true);
        }

    }
])