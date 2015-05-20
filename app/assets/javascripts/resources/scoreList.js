angular.module('app').factory('ScoreList', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/score_lists',
        name: 'score_list'
    })
}]);
