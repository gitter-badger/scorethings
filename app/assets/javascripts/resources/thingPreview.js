angular.module('app').factory('ThingPreview', ['Restangular', function(Restangular) {
    return Restangular.service('thing_preview');
}]);