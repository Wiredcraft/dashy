angular.module('Dashboard.AdminDirectives', [])

// for widget list
.directive('options', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            widget: '='
        },
        templateUrl: 'partials/admin/THIS_TEMPLATE.html',
        controller: function($scope, $element, $location, Admin) {

        }
    };
})