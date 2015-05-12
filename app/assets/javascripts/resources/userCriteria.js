angular.module('app').factory('UserCriteria', ['Restangular', 'identity', function(Restangular, identity) {
    return Restangular.service('criteria', Restangular.one('users', identity.userId));
}]);