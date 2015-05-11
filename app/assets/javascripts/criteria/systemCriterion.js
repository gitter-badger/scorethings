angular.module('app').directive('systemCriterion', [function() {
    return {
        restrict: 'E',
        replace: true,
        criterion: {
            criterion: '='
        },
        templateUrl: 'criteria/systemCriterion.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
