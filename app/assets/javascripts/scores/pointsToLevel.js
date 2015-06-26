angular.module('app').service('pointsToLevel', function() {
    return {
        translate: function(points) {
            if(points <=5) {
                return 'No';
            } else if(points <8) {
                return 'Meh';
            } else {
                return 'Yes';
            }
        }
    }

});