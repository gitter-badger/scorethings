angular.module('app').directive('scorePanel', ['identity', function(identity) {
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
