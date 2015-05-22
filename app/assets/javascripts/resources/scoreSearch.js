angular.module('app').factory('ScoreSearch', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/scores/search',
        name: 'score'
    });
}]);