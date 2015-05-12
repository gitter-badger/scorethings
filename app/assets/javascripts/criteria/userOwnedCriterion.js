angular.module('app').directive('userOwnedCriterion', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            criterion: '='
        },
        templateUrl: 'criteria/userOwnedCriterion.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
