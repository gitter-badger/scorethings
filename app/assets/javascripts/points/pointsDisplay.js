angular.module('app').directive('pointsDisplay', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'points/pointsDisplay.html',
        scope: {
            points: '='
        }
    };
});