angular.module('app').factory('ScoredThing', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/scored_things',
        name: 'scored_thing'
    });
}]);
