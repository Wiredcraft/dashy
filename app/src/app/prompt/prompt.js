angular.module('Dashboard.Prompt', [])

.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
        controller: 'PromptCtrl',
        templateUrl: 'prompt/prompt.tpl.html'
    })
})

.directive('prompt', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'prompt/prompt.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // Controller
            $scope.test = function() {
                console.log('I was clicked!');
            }
        }
    };
})

;