// Declare app level module which depends on filters, and services
var DashboardApp = angular.module('Dashboard', [
    // controllers
    'Dashboard.Controllers',
    'Dashboard.Admin',

    // models
    'Dashboard.Models',

    // directives
    'Dashboard.Tags',
    'Dashboard.Charts',

    // filters
    'Dashboard.Filters',
    'Dashboard.Formatters',

    // utils
    'Dashboard.Utils'
]).config(['$routeProvider',
    function($routeProvider) {
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
]);

