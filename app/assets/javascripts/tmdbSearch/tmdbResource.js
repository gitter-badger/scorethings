angular.module('yeaskme').factory('tmdbResource', ['$q', function($q) {
    return {
        movie: function(id) {
            var deferred = $q.defer();
            theMovieDb.movies.getById(({"id": id}),
                function(data) {
                    deferred.resolve(data);
                },
                function(resp) {
                    deferred.reject('Failed to load movies: ' + resp);
                }
            );
            return deferred.promise;
        },
        tv: function(id) {
            var deferred = $q.defer();
            theMovieDb.tv.getById(({"id": id}),
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