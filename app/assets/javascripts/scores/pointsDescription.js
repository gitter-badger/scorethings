angular.module('app').filter('pointsDescription', function() {
    return function(points) {
        if(points < 60) {
            return 'NO';
        } else if(points < 80) {
            return 'MEH';
        } else {
            return 'YES';
        }
    };
});