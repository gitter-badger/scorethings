angular.module('app').controller('ScoresDetailCtrl', ['$scope', '$stateParams', 'Score', 'notifier', function($scope, $stateParams, Score, notifier) {
    var scoreId = $stateParams.scoreId;

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