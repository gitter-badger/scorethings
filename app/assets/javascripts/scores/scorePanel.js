angular.module('app').directive('categoryPanel', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            score: '='
        },
        templateUrl: 'scores/scorePanel.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
