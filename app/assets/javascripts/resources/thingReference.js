angular.module('app').factory('ThingReference', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/thing_references',
        name: 'thing_reference'
    });
}]);
