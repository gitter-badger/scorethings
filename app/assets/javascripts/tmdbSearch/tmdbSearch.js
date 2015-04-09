angular.module('yeaskme').factory('tmdbSearch', ['$q', function($q) {
    return {
        movie: function(query) {
            var deferred = $q.defer();
            theMovieDb.search.getMovie(({"query": query}),
                function(data) {
                    deferred.resolve(data);
                },
                function(resp) {
                    deferred.reject('Failed to search for movies: ' + resp);
                }
            );
            return deferred.promise;
        },
        tvShows: function(query) {
            var deferred = $q.defer();
            theMovieDb.search.getTv(({"query": query}),
                function(data) {
                    deferred.resolve(data);
                },
                function(resp) {
                    deferred.reject('Failed to search for tv shows: ' + resp);
                }
            );
            return deferred.promise;
        }
    };
}]);