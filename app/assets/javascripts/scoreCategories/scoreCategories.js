angular.module('app').factory('scoreCategoriesData', function() {
    var data = {};
    return {
        get: function() {
            return data;
        },
        set: function(dataInput) {
           data = dataInput;
        }
    };
});
