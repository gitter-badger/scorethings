angular.module('app').directive('userOwnedCriterion', [function() {
    return {
        restrict: 'E',
        replace: true,
        criterion: {
            criterion: '='
        },
        templateUrl: 'criteria/userOwnedCriterion.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
