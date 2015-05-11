angular.module('app').filter('criterionSign', function() {
        return function(sign) {
            if(sign < 0) {
                return "A Negative";
            } else {
                return "A Positive";
            }
        };
    })