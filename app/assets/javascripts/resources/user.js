angular.module('app').factory('User', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/users',
        name: 'user'
    });
}]);
