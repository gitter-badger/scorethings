angular.module('app').controller('TMDBSearchCtrl', ['$scope', 'tmdbSearch', 'tmdbSearchResultFacade', 'notifier', function($scope, tmdbSearch, tmdbSearchResultFacade, notifier) {
    $scope.searchSource = 'tmdbMovie';
    $scope.searchResults = {};

    var handleError = function(msg) {
        notifier.error(msg);
    };

    var search = {
        movie: function(query, successFn) {
            tmdbSearch.movie(query).then(
                function success(data) {
                    return successFn(tmdbSearchResultFacade.buildFromMovieSearchResults(data));
                },
                handleError
            );
        },
        tvShows: function(query, successFn) {
            tmdbSearch.tvShows(query).then(
                function success(data) {
                    return successFn(tmdbSearchResultFacade.buildFromTVSearchResults(data));
                },
                handleError
            );
        }
    };

    var handleTMDBSearchResults = function(results) {
        $scope.searchResults = results;
    };

    $scope.submitSearch = function() {
        $scope.searchResults = {};

        if($scope.searchSource === 'tmdbMovie') {
            search.movie($scope.query, handleTMDBSearchResults);
        } else if($scope.searchSource === 'tmdbTV') {
            search.tvShows($scope.query, handleTMDBSearchResults);
        }
    };
}]);