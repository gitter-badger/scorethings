angular.module('app').controller('ShowScoreCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreCategoriesData', 'scoreModalFactory', '$state', function($scope, $stateParams, Score, notifier, identity, scoreCategoriesData, scoreModalFactory, $state) {
    var scoreId = $stateParams.scoreId;
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

    $scope.save = function() {

    };


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

    $scope.changeScore = function() {
        scoreModalFactory.updateScore($scope.score,
            function saveSuccessCallbackFn(updatedScore) {
                console.log(updatedScore);
                notifier.success('you updated the score for : ' + updatedScore.webThing.title);
                $scope.score = updatedScore;
            },
            function saveErrorCallbackFn() {
                notifier.error('failed to update score');
                return;
            });
    };

    $scope.scoreThisThing = function() {
        scoreModalFactory.createNewScoreForThing($scope.score.thing,
            function saveSuccessCallbackFn(createdScore) {
                console.log(createdScore);
                notifier.success('you scored the thing: ' + createdScore.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function(response) {
                notifier.error('failed to score the thing: ' + $scope.score.thing.title);
                return;
            });
    };
}]);
