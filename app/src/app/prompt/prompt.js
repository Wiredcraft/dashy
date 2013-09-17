angular.module('Dashboard.Prompt', [])

.directive('prompt', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'prompt/prompt.tpl.html',
        controller: function($scope, $rootScope, $location, Admin, Sources, Widgets) {
            // Do this when closing the panel & on app start
            var reset_panel = function() {
                $scope.id = '';
                $scope.updating = false;
                $scope.adding = true;
                $scope.editingContent = false;
                $scope.cIndex = '';
                $scope.content = {};
                $scope.widget = {config: {}, content: [],layout: {}};
                $scope.content = {};
                $location.hash('');
                $rootScope.showAdmin = false;
            };
            reset_panel();

            // Get datasources
            Sources.getSources().then(function(data) {
                $scope.sources = data;
            });

            // Get templates in /js/config/config.json, not being used currently
            Sources.getTemplates().then(function(data) {
                $scope.dbWidgets = data[0];
            });

            // If routeChange & has location hash, set up & show panel
            $scope.$on('$routeChangeStart', function() {
                if($location.hash()) {
                    $rootScope.showAdmin = true;
                    $scope.id = $location.hash();
                    $scope.updating = true;
                    $scope.adding = false
                
                    Widgets.getWidgetById($scope.id).then(function(data) {
                        $scope.widget = data;
                        $scope.thisTitle = data.config.title;
                    });
                }
            });

            // Block Selector
            $scope.test = function(type) {
                var len = $scope.widget.content.length
                $scope.widget.content.push({'template': type, 'refresh': 0, 'options': {}});
                $scope.content = $scope.widget.content[len];
                $scope.editingContent = true;
                $scope.cIndex = len;
            }

            // Options Functions
            $scope.contentRemove = function(index) {
                var del = confirm('Delete this item? This action cannot be undone.')
                if (del) {
                    $scope.widget.content.splice(index, 1);
                }
            };

            $scope.contentEdit = function(index) {
                $scope.content = $scope.widget.content[index];
                $scope.editingContent = true;
                $scope.cIndex = index;
            };

            $scope.contentUpdate = function() {
                $scope.widget.content[$scope.cIndex] = $scope.content;
                $scope.editingContent = false;
                $scope.content = {};
                $scope.cIndex = '';
            };

            // Panel Functions
            $scope.save = function(widget) {
                if($scope.updating === true) {
                    Admin.updateWidget($scope.id, widget).then(function(data) {
                        reset_panel();
                    });
                } else if($scope.adding === true) {
                    Admin.addWidget(widget).then(function(data) {
                        reset_panel();
                        document.location.reload(true);
                    });
                }
            };

            $scope.cancel = function() {
                reset_panel()
            };

            $scope.delete = function() {
                // INCLUDE if statement > if widget to delete
                var del = confirm('Delete this widget? This action cannot be undone.')
                if (del) {
                    Admin.deleteWidget($scope.id);
                    reset_panel();
                    document.location.reload(true);
                }
            };

        }
    };
})

;
