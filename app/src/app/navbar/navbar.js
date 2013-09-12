angular.module('Dashboard.Navbar', [])

.directive('navbar', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'navbar/navbar.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // Modal Controls
            $scope.opts = {
                backdropFade: false,
                dialogFade: true
            };
            $scope.open = function() {
                $scope.shouldBeOpen = true;
            };
            $scope.close = function() {
                $scope.shouldBeOpen = false;
            };

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