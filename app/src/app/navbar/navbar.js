angular.module('Dashboard.Navbar', [])

.directive('navbar', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'navbar/navbar.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // Show / Hide Admin panel
            $scope.open = function() {
                if($rootScope.showAdmin) {
                    $location.hash('');
                    $rootScope.showAdmin = false;
                } else {
                    $rootScope.showAdmin = true;
                }
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

            // Refresh Page
            $scope.refresh = function() {
                document.location.reload(true);
            }
        }
    };
})

;