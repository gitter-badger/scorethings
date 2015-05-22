angular.module('app').factory('ScoreCategory', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/score_categories',
        name: 'score_category'
    })
}]);