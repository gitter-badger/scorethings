angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', '$stateParams', 'identity', function($scope, Score, $stateParams, identity) {
    $scope.identity = identity;
    console.log(identity);
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            updateCanEditScore();
        },
        function errorGet() {
            $scope.notFound = true;
        });

    $scope.$watch('identity', function(val) {
        updateCanEditScore();
    });

    function updateCanEditScore() {
        console.log(identity)
        if($scope.score) {
            $scope.canEditScore = (identity.userId == $scope.score.user.id);
        } else {
            $scope.canEditScore = false;
        }
    }
    $scope.updatePoints = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                $scope.score = updatedScore;
                $scope.updateScoreForm.$setPristine();
            },
            function errorUpdate(response) {
                notifier.error('failed to update points');
                console.error(response);
            }
        )
    };
}]);
