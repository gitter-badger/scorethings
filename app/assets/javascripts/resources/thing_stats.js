angular.module('app').factory('ThingStats', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/thing_stats',
        name: 'thing_stats'
    });
}]);
