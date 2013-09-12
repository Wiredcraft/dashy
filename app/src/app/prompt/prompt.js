angular.module('Dashboard.Prompt', [])

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