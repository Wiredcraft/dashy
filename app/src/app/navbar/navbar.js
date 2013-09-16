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

            // Refresh Page
            $scope.refresh = function() {
                document.location.reload(true);
            }

            // jQuery
            var showDistance = 50;
            var animateSpeed = 300 //ms

            $(document).ready(function() {
                $("#menu").hide();
            });

            function showNavBar() {
                $("#menu").show(animateSpeed, 'linear');
            };

            $rootScope.$watch('showAdmin', function() {
                if($rootScope.showAdmin === true) {
                    showNavBar();
                }
            });

            $(document).mousemove(function(ev) {
                var ev = ev || window.event;
                if(ev.pageX <= showDistance) {
                    showNavBar();
                } else if ($rootScope.showAdmin === false && ev.pageX > showDistance) {
                    $("#menu").hide(animateSpeed, 'linear');
                }
            });
        }
    };
})

;