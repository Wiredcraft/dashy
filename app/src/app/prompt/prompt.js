angular.module('Dashboard.Prompt', [])

.directive('prompt', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'prompt/prompt.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // If page load with #widgetTitle, show panel
            if($location.hash()) {
                $rootScope.hideAdmin = true;
            }

            // If routeChange && has location hash, set up panel
            $scope.$on('$routeChangeStart', function() {
                if($location.hash()) {
                    console.log('Hash: '+$location.hash());
                    $scope.hash = $location.hash();
                }
            })

            $scope.test = function() {
                console.log('I was clicked!');
            }

            $scope.cancel = function() {
                $location.hash('');
                $rootScope.hideAdmin = false;
            }

            $scope.delete = function() {
                var del = confirm('Delete this widget? This action cannot be undone.')
                if (del) {
                    // Admin.deleteWidget(THIS_ID);
                    $location.hash('');
                    $rootScope.hideAdmin = false;
                }
            }
        }
    };
})

;