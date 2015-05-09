angular.module('app').factory('Score', ['Restangular', function(Restangular) {
    return Restangular.service('scores');
}]);