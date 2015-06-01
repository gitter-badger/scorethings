angular.module('app').factory('WebThing', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/web_things',
        name: 'web_thing'
    });
}]);
