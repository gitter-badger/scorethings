angular.module('app').factory('scoreCategoriesData', function() {
    var allScoreCategories = {};
    var generalScoreCategory = {};
    return {
        get: function() {
            return allScoreCategories;
        },
        getGeneralScoreCategory: function() {
            return generalScoreCategory;
        },
        set: function(dataInput) {
            allScoreCategories = dataInput;
            generalScoreCategory = dataInput['general'];
            delete allScoreCategories['general'];
        }
    };
});
