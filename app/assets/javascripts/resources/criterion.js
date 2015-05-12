angular.module('app').factory('Criterion', ['Restangular', function(Restangular) {
    return Restangular.service('criteria');
}]);