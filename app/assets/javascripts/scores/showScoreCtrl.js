angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', '$stateParams', 'identity', function($scope, Score, $stateParams, identity) {
    $scope.identity = identity;
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
        },
        function errorGet() {
            $scope.notFound = true;
        });

    $scope.updatePoints = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                $scope.score = updatedScore;
            },
            function errorUpdate(response) {
                notifier.error('failed to update points');
                console.error(response);
            }
        )
    };
}]);
