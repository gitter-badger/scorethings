angular.module('app').factory('scoreCategories', ['$http', '$q', function($http, $q) {
    return {
        getAll: function() {
            var deferred = $q.defer();
            $http.get('/api/v1/score_categories', null, {cached: true})
                .then(function(response) {
                    if(!response.data || !response.data.score_categories) {
                        deferred.reject('score category data was not formatted correctly');
                    }
                    var scoreCategoriesMap = {};
                    var generalScoreCategory;

                    var scoreCategories = response.data.score_categories;

                    angular.forEach(scoreCategories, function(scoreCategory) {
                        if(scoreCategory.general) {
                            generalScoreCategory = scoreCategory;
                        }
                        scoreCategoriesMap[scoreCategory.id] = scoreCategory;
                    });

                    deferred.resolve({
                        scoreCategoriesMap: scoreCategoriesMap,
                        generalScoreCategory: generalScoreCategory
                    });
                }, function error() {
                    deferred.reject('failed to get score categories');
                });
            return deferred.promise;
        }
    };

}]);