angular.module('app').controller('ShowScoreCtrl', ['$scope', '$routeParams', 'Score', 'notifier', function($scope, $routeParams, Score, notifier) {
    var scoreId = $routeParams.scoreId;

    Score.one(scoreId).get().then(
        function successGet(response) {
            $scope.score = response.score;
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });
}]);