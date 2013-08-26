angular.module('Dashboard.Tags', [])

// for widget list
.directive('widgets', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            widgets: '='
        },
        templateUrl: 'partials/widgets.html',
        controller: function($rootScope, $scope, $element, $location, Admin) {
            // cache it for global use
            $rootScope.gridster = $element.gridster({
                widget_margins: [5, 5], //widget margin
                widget_base_dimensions: [140, 140], //widget base dimensions
                min_cols: 12
                // draggable: {handle: '.handle'} // Only class 'handle' allows dragging
            }).data('gridster');
            $rootScope.gridster.disable();
            $rootScope.locked = true;

            $scope.updateWidget = function(id, rev) {
                $location.path('update').hash(id);
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

// dynamic widget middlerware
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
            
            // dynamic create chart directive
            var dynamicDirective = function () {
                var oDirective = JSON.parse($scope.templates),
                    sHtml = '';

                // Start Section
                sHtml += '<section class="widget-body number-widget">';
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
