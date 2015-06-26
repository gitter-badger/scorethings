angular.module('app').service('pointsToLevel', function() {
    return {
        translate: function(points) {
            if(points <=5) {
                return 'NO';
            } else if(points <8) {
                return 'MEH';
            } else {
                return 'YES';
            }
        }
    }

});