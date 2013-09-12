angular.module('Dashboard.Update', [])

.directive('update', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'modal_update/updatewidget.tpl.html',
        controller: function($scope, $http, $location, Admin, Sources, Widgets) {
            // Define content
            $scope.content = {"type": "data"};
            $scope.content.options = {};

            // Get widget ID
            var id = $location.hash();
            var thisId = id;

            // Get the widget to edit
            Widgets.getWidgetById(thisId).then(function(data) {
                $scope.widget = data;
                $scope.thisTitle = data.config.title;
            });

            // Get list of useable datasources
            Sources.getSources().then(function(data) {
                $scope.sources = data;
            });

            // Get templates in /js/config/config.json
            Sources.getTemplates().then(function(data) {
                $scope.dbWidgets = data[0];
            });

            // Content Functions
            $scope.contentAdd = function(content) {
                $scope.widget.content.push({
                    "type": content.type,
                    "source": content.source,
                    "refresh": content.refresh,
                    "dataKey": content.dataKey,
                    "template": content.template,
                    "options": content.options
                });
                $scope.content = {"type": "data"};
                $scope.content.options = {};
            }
            $scope.contentRemove = function(index) {
                $scope.widget.content.splice(index, 1);
            }

            // Update Function
            $scope.updateWidget = function(widget) {
                Admin.updateWidget(id, widget).then(function(data) {
                    $location.path('');
                });
            };

        }
    }
})

;