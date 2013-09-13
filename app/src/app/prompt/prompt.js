angular.module('Dashboard.Prompt', [])

.directive('prompt', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'prompt/prompt.tpl.html',
        controller: function($scope, $rootScope, $location) {
            // Adding not Editing by default
            $scope.adding = true;

            // If routeChange & has location hash, set up & show panel
            $scope.$on('$routeChangeStart', function() {
                if($location.hash()) {
                    $rootScope.showAdmin = true;
                    $scope.hash = $location.hash();
                    $scope.updating = true;
                    $scope.adding = false
                }
            });

            // Save
            $scope.save = function() {
                console.log('I\'m the save function!');
            }

            // Cancel
            $scope.cancel = function() {
                reset_panel()
            }

            // Delete
            $scope.delete = function() {
                // INCLUDE if statement > if widget to delete
                var del = confirm('Delete this widget? This action cannot be undone.')
                if (del) {
                    // Admin.deleteWidget(THIS_ID);
                    reset_panel();
                }
            }

            // Do this when closing the panel
            var reset_panel = function() {
                $scope.hash = '';
                $scope.updating = false;
                $scope.adding = true;
                $location.hash('');
                $rootScope.showAdmin = false;    
            }

        }
    };
})

;