angular.module('Dashboard.Navbar', [

])

.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
        controller: 'NavCtrl',
        templateUrl: 'navbar/navbar.tpl.html'
    })
})

.controller('NavCtrl', ['$scope', '$rootScope', '$location',
    function($scope, $rootScope, $location) {
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
])

;