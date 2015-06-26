angular.module('app').filter('pointsDescription', ['pointsToLevel', function(pointsToLevel) {
    return function(points) {
        return pointsToLevel.translate(points);
    };
}]);