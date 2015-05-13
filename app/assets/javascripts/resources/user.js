// copied from http://stackoverflow.com/a/27891906/4694250
angular.module('app').factory('User', ['Restangular', function(Restangular) {
    return {
        getScores: function(id) {
            return Restangular.one('users', id).one('scores').get();
        }
    }
}]);