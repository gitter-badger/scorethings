angular.module('app').directive('scorePointsInput', function() {
    return {
        restrict: 'E',
        replace: 'false',
        templateUrl: "scores/scorePointsInput.html",
        scope: {
            score: '=',
            isOwner: '='
        },
        controller: ['$scope', function($scope) {
        }]
    };
});