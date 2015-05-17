angular.module('app').factory('scoreCategories', ['$http', '$q', function($http, $q) {
    return {
        getAll: function() {
            var deferred = $q.defer();
            $http.get('/api/v1/score_categories', null, {cached: true})
                .then(function(response) {
                    if(!response.data || !response.data.score_categories) {
                        deferred.reject('score category data was not formatted correctly');
                    }
                    var scoreCategories = response.data.score_categories;

                    deferred.resolve(scoreCategories);
                }, function error() {
                    deferred.reject('failed to get score categories');
                });
            return deferred.promise;
        }
    };

}]);