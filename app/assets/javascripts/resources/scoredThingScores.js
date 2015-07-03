angular.module('app').factory('ScoredThingScores', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/scored_things/{{scoreThingId}}/scores',
        name: 'scores'
    });
}]);
