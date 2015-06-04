angular.module('app').factory('Thing', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/things',
        name: 'thing'
    });
}]);
