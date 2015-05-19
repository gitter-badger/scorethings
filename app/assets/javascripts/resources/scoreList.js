angular.module('app').factory('ScoreList', ['Restangular', function(Restangular) {
    return Restangular.service('score_lists');
}]);