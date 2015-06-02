angular.module('app').controller('ShowScoreCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreCategoriesData', 'scoreModalFactory', '$state', function($scope, $stateParams, Score, notifier, identity, scoreCategoriesData, scoreModalFactory, $state) {
    var scoreId = $stateParams.scoreId;
    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            console.log(score);
            updateIsOwner();
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });

    $scope.scoreCategories = scoreCategoriesData.get();
    $scope.isOwner = false;

    function updateIsOwner() {
        console.log('updating owner')
        $scope.isOwner = identity.userId == $scope.score.user.id;
        console.log('userid: ', $scope.score.user.id)
    }

    $scope.$on('userLogsIn', function() {
        updateIsOwner();
    });

    $scope.$on('userLogsOff', function() {
        $scope.isOwner = false;
        console.log('updating owner')
        console.log('userid: ', $scope.score.user.id)
    });

    $scope.updateScore = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                notifier.success('you updated the score for : ' + updatedScore.webThing.title);
                $scope.score = updatedScore;
            },
            function errorUpdate() {
                notifier.error('failed to update score');
            });
    };

    $scope.scoreThisThing = function() {
        scoreModalFactory.createNewScoreForThing($scope.score.thing,
            function saveSuccessCallbackFn(createdScore) {
                console.log(createdScore);
                notifier.success('you scored the thing: ' + createdScore.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function() {
                notifier.error('failed to score the thing: ' + $scope.score.thing.title);
                return;
            });
    };
}]);
