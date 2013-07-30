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
        controller: function($rootScope, $scope, $element, Admin) {
            // cache it for global use
            $rootScope.gridster = $element.gridster({
                widget_margins: [5, 5], //widget margin
                widget_base_dimensions: [140, 140], //widget base dimensions
                min_cols: 12,
                draggable: {handle: '.handle'}
            }).data('gridster');
            // $rootScope.gridster.disable();

            $scope.updateWidget = function(id, rev) {
                console.log(id);
                console.log(rev);
            }

            $scope.deleteWidget = function(id) {
                console.log(id);
                Admin.deleteWidget(id);
            }

        }
    };
})

// dynamic widget middlerware
.directive('widget', function() {
    return {
        restrict: 'E',
        scope: {
            templates: '@',
            data: '@',
            layout : '@'
        },
        controller: function($rootScope, $scope, $element, $compile) {
            // add widget element to gridster
            var gridWidget = function () {
                var oLayout = JSON.parse($scope.layout);
                $rootScope.gridster.add_widget($element.parent(), oLayout['data-sizex'], oLayout['data-sizey'], oLayout['data-col'], oLayout['data-row']);
            }
            
            // dynamic create chart directive
            var dynamicDirective = function () {
                var oDirective = JSON.parse($scope.templates),
                    sHtml = '';

                // Start Section
                sHtml += '<section class="widget-body number-widget">';
                // Add directives to section
                angular.forEach(oDirective, function (directive, directiveName) {
                    sHtml += '<' + directiveName + ' data="{{data}}" templates="{{templates}}"></' + directiveName + '>';
                });
                // End Section
                sHtml += '</section>';
                // Complete
                $element.replaceWith($compile(sHtml)($scope));
            }

            $scope.$watch('data', function (aft, bef) {
                if (aft) {
                    gridWidget();
                    dynamicDirective();
                }
            });
        }
    };
});
