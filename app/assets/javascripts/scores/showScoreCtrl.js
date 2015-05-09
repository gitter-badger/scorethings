angular.module('app').controller('ShowScoreCtrl', ['$scope', '$routeParams', 'Restangular', function($scope, $routeParams, Restangular) {
    var scoreId = $routeParams.scoreId;
    Restangular.one('scores', scoreId).get().then(function(data) {
        $scope.score =  data.score;
    });
}]);