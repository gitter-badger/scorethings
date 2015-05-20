angular.module('app').controller('ShowScoreCtrl', ['$scope', '$routeParams', 'Score', 'notifier', function($scope, $routeParams, Score, notifier) {
    var scoreId = $routeParams.scoreId;

    Score.get(scoreId).then(
        function successGet(score) {
            console.log(score);
            $scope.score = score;
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });
}]);