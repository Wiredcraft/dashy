// Declare app level module which depends on filters, and services
angular.module('Dashboard', [
    'templates-app',
    'templates-common',

    'Dashboard.Navbar',

    // directives
    'Dashboard.Tags',
    'Dashboard.Charts',

    // filters
    'Dashboard.Filters',
    'Dashboard.Formatters'

]).config(['$routeProvider', '$locationProvider',
    function($routeProvider, $locationProvider) {
        $routeProvider.when('/', {
            templateUrl: 'partials/layout.html',
            controller: 'MainAppCtrl'
        }).when('/add', {
            templateUrl: 'partials/addwidget.html',
            controller: 'AddCtrl'
        }).when('/update', {
            templateUrl: 'partials/updatewidget.html',
            controller: 'UpdateCtrl'
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

