angular.module('Dashboard.Prompt', [])

.directive('prompt', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'prompt/prompt.tpl.html',
        controller: function($scope, $rootScope, $location, Admin, Sources, Widgets) {
            // Do this when closing the panel & on app start
            var reset_panel = function() {
                $scope.hash = '';
                $scope.updating = false;
                $scope.adding = true;
                $scope.widget = {config: {}, content: [],layout: {}};
                $scope.content = {};
                $scope.content.options = {};
                $location.hash('');
                $rootScope.showAdmin = false;
            }
            reset_panel();

            // Get datasources
            Sources.getSources().then(function(data) {
                $scope.sources = data;
            });

            // Get templates in /js/config/config.json
            Sources.getTemplates().then(function(data) {
                $scope.dbWidgets = data[0];
            });

            // If routeChange & has location hash, set up & show panel
            $scope.$on('$routeChangeStart', function() {
                if($location.hash()) {
                    $rootScope.showAdmin = true;
                    $scope.hash = $location.hash();
                    $scope.updating = true;
                    $scope.adding = false
                
                    Widgets.getWidgetById($scope.hash).then(function(data) {
                        $scope.widget = data;
                        $scope.thisTitle = data.config.title;
                    });
                }
            });

            // Options Functions
            $scope.contentRemove = function(index) {
                $scope.widget.content.splice(index, 1);
            }
            $scope.contentEdit = function(index) {
                $scope.content = $scope.widget.content[index];
                $scope.editingContent = true;
                $scope.cIndex = index;
            }
            $scope.contentUpdate = function() {
                $scope.widget.content[$scope.cIndex] = $scope.content;
                $scope.editingContent = false;
                $scope.cIndex = '';
            }

            // Panel Functions
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

        }
    };
})

;