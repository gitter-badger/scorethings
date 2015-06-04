angular.module('app').factory('Settings', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/settings',
        name: 'settings'
    });
}]);