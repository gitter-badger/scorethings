angular.module('app').controller('ScoreIndexCtrl', ['$scope', 'Restangular', function($scope, Restangular) {
    Restangular.all('scores').getList().then(function(scores) {
        $scope.scores =  scores;
    });
}]);

