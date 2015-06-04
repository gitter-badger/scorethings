angular.module('app').factory('Profile', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/user_profiles',
        name: 'profile'
    });
}]);
