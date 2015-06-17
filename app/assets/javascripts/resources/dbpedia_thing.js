angular.module('app').factory('DbpediaThing', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/dbpedia_things',
        name: 'dbpedia_thing'
    });
}]);
