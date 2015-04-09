angular.module('yeaskme').factory('tmdbSearchResultFacade', function() {
    return {
        buildFromMovieSearchResults: function(unformattedResults) {
            unformattedResults = JSON.parse(unformattedResults);
            if(!unformattedResults || !unformattedResults.results) return {};

            var searchResults = unformattedResults.results;

            var formattedSearchResults = searchResults.map(function(searchResult) {
                return {
                    title: searchResult.title,
                    date: searchResult.release_date,
                    image: searchResult.poster_path && theMovieDb.common.images_uri + 'w45' + searchResult.poster_path
                };
            });

            return {
                page: unformattedResults.page,
                totalPages: unformattedResults.total_pages,
                totalResults: unformattedResults.total_results,
                results: formattedSearchResults
            };
        },
        buildFromTVSearchResults: function(unformattedResults) {
            unformattedResults = JSON.parse(unformattedResults);
            if(!unformattedResults || !unformattedResults.results) return {};

            var searchResults = unformattedResults.results;

            var formattedSearchResults = searchResults.map(function(searchResult) {
                return {
                    title: searchResult.name,
                    date: searchResult.first_air_date,
                    image: searchResult.poster_path && theMovieDb.common.images_uri + 'w45' + searchResult.poster_path
                };
            });

            return {
                page: unformattedResults.page,
                totalPages: unformattedResults.total_pages,
                totalResults: unformattedResults.total_results,
                results: formattedSearchResults
            };
        }
    };
});
