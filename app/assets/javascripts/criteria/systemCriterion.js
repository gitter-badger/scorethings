angular.module('app').directive('systemCriterion', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            criterion: '='
        },
        templateUrl: 'criteria/systemCriterion.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
