angular.module('app').factory('Stats', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/stats',
        name: 'stats'
    });
}]);
