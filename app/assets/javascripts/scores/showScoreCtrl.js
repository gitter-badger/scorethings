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
            updateIsOwner();
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });

    $scope.scoreThisThing = function() {
        var scoreInput = {thing: $scope.score.thing};
        scoreModalFactory.openModal(scoreInput,
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
