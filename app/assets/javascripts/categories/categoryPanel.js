angular.module('app').directive('categoryPanel', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            category: '='
        },
        templateUrl: 'categories/categoryPanel.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
