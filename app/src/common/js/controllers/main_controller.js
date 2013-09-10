angular.module('Dashboard.Controllers', ['ui.bootstrap'])

// Main controller
.controller('MainAppCtrl', ['$scope', 'Widgets', '$rootScope', '$document',
    function($scope, Widgets, $rootScope, $document) {
        // Get widgets
        Widgets.getWidgetList().then(function(data) {
            $scope.widgets = data;
        }, function(err) {
            console.log(err);
        });

        // Press 'L' to un/lock dragging
        $document.keydown(function(e) {
            // console.log(e.keyCode);
            if (e.keyCode === 76) {
                if($rootScope.locked === false) {
                    $rootScope.gridster.disable();
                    $rootScope.locked = true;
                } else if($rootScope.locked === true) {
                    $rootScope.gridster.enable();
                    $rootScope.locked = false;
                }                
            }
        });

    }
])

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