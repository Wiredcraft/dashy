angular.module('Dashboard.Navbar', [])

.directive('navbar', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'navbar/navbar.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // Show / Hide Admin
            $scope.open = function() {
                if($rootScope.hideAdmin) {
                    $rootScope.hideAdmin = false
                } else {
                    $rootScope.hideAdmin = true;
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

            // Manually refresh widget data.
            // For now refreshes whole page.
            $scope.refresh = function() {
                document.location.reload(true);
            }
        }
    };
})

;