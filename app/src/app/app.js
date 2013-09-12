// Declare app level module which depends on filters, and services
angular.module('Dashboard', [
    'ui.bootstrap',
    'templates-app',
    'templates-common',

    'Dashboard.Grid',
    'Dashboard.Navbar',
    'Dashboard.Prompt',
    'Dashboard.Blocks',
    'Dashboard.Add',
    'Dashboard.Update',

    // filters
    'Dashboard.Models',
    'Dashboard.Filters',
    'Dashboard.Formatters'

]).config(['$routeProvider', '$locationProvider',
    function($routeProvider, $locationProvider) {
        $routeProvider.when('/', {
            templateUrl: 'grid/grid_templates/layout.tpl.html',
            controller: 'MainAppCtrl'
        }).otherwise({
            redirectTo: '/404'
        });
    }
])

// Main controller
.controller('MainAppCtrl', ['$scope', 'Widgets', '$rootScope', '$document',
    function($scope, Widgets, $rootScope, $document) {
        // Get widgets
        Widgets.getWidgetList().then(function(data) {
            $scope.widgets = data;
        }, function(err) {
            console.log(err);
        });

        // Press 'L' to un/lock dragging
        $document.keydown(function(e) {
            // console.log(e.keyCode);
            if (e.keyCode === 76) {
                if($rootScope.locked === false) {
                    $rootScope.gridster.disable();
                    $rootScope.locked = true;
                } else if($rootScope.locked === true) {
                    $rootScope.gridster.enable();
                    $rootScope.locked = false;
                }
            }
        });

    }
])

;

