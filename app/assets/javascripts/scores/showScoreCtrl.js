angular.module('app').controller('ShowScoreCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreModalFactory', '$state', function($scope, $stateParams, Score, notifier, identity, scoreModalFactory, $state) {
    var scoreId = $stateParams.scoreId;
    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            $scope.thing = score.thing;
            updateIsOwner();
        },
        function errorGet() {
            notifier.error('failed to get score');
        });

    $scope.isOwner = false;

    function updateIsOwner() {
        $scope.isOwner = identity.userId == $scope.score.user.id;
    }

    $scope.$on('userLogsIn', function() {
        updateIsOwner();
    });

    $scope.$on('userLogsOff', function() {
        $scope.isOwner = false;
    });

    $scope.updateScore = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                notifier.success('you updated the score for : ' + updatedScore.thing.title);
                $scope.score = updatedScore;
            },
            function errorUpdate() {
                notifier.error('failed to update score');
            });
    };

    $scope.scoreThisThing = function() {
        scoreModalFactory.createNewScoreForThing($scope.score.thing, $scope.thing,
            function saveSuccessCallbackFn(createdScore) {
                notifier.success('you scored the thing: ' + createdScore.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function() {
                notifier.error('failed to score the thing_reference: ' + $scope.score.thing.title);
                return;
            });
    };
}]);
