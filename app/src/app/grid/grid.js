angular.module('Dashboard.Grid', [])

// for widget list
.directive('widgets', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            widgets: '='
        },
        templateUrl: 'grid/grid_templates/widgets.tpl.html',
        controller: function($rootScope, $scope, $element, $location, Admin) {
            // Gridster options
            $rootScope.gridster = $element.gridster({
                widget_margins: [20, 20], //widget margin
                widget_base_dimensions: [120, 130], //widget base dimensions
                min_cols: 12
            }).data('gridster');
            $rootScope.gridster.disable();
            $rootScope.locked = true;

            // Open edit pane
            $scope.edit = function(id, rev) {
                $location.hash(id);
                $rootScope.showAdmin = true;
            };

            $scope.deleteWidget = function(id) {
                var del = confirm('Delete this widget? This action cannot be undone.')
                if (del) {
                    Admin.deleteWidget(id);
                    document.location.reload(true);
                }
            };

        }
    };
})

// dynamic widget middleware
.directive('widget', function() {
    return {
        restrict: 'E',
        scope: {
            templates: '@',
            layout : '@'
        },
        controller: function($rootScope, $scope, $element, $compile) {
            // add widget element to gridster
            var gridWidget = function () {
                var oLayout = JSON.parse($scope.layout);
                $rootScope.gridster.add_widget($element.parent(), oLayout['width'], oLayout['height'], oLayout['column'], oLayout['row']);
            }
            
            // dynamically create directive
            var dynamicDirective = function () {
                var oDirective = JSON.parse($scope.templates),
                    sHtml = '';

                // Start Section
                sHtml += '<section class="body">';
                // Add directives to section
                angular.forEach(oDirective, function (data, index) {
                    var directiveName = data.template;
                    sHtml += '<' + directiveName + ' data="{{data}}" templates="{{templates}}"></' + directiveName + '>';
                });
                // End Section
                sHtml += '</section>';
                // Complete
                $element.replaceWith($compile(sHtml)($scope));
            }

            // Setup placement of widgets and add templates on load
            $scope.$watch('templates', function (aft, bef) {
                if (aft) {
                    gridWidget();
                    dynamicDirective();
                }
            });
        }
    };
});
