angular.module('app').factory('Score', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/scores',
        name: 'score'
    })
}]);