angular.module('app').directive('userOwnedScore', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            score: '='
        },
        templateUrl: 'scores/userOwnedScore.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
