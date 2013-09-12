angular.module('Dashboard.Prompt', [

])

.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
        controller: 'PromptCtrl',
        templateUrl: 'prompt/prompt.tpl.html'
    })
})

.controller('PromptCtrl', ['$scope', '$rootScope', '$location',
    function($scope, $rootScope, $location) {
        // Prompt Controller Options
        $scope.test = function() {
            console.log('Clicked!!');
        }

        $scope.words = 'Some most excellent content! :D';
    }
])

;