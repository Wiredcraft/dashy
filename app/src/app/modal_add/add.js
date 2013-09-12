angular.module('Dashboard.Add', [])

.directive('add', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'modal_add/addwidget.tpl.html',
        controller: function($scope, $http, $location, Admin, Sources) {
            // Define widget & content
            $scope.widget = {config: {}, content: [],layout: {}};
            $scope.content = {"type": "data"};
            $scope.content.options = {};

            // Get list of useable datasources
            Sources.getSources().then(function(data) {
                $scope.sources = data;
            });

            // Get templates in /js/config/config.json
            Sources.getTemplates().then(function(data) {
                $scope.dbWidgets = data[0];
            });

            // Content Options
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

            // Add widget function
            $scope.addWidget = function(widget){
                Admin.addWidget($scope.widget).then(function(data) {
                    document.location.reload(true);
                });
            };
        }
    }
})

;