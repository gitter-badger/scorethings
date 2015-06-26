angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', 'ThingStats', '$stateParams', 'identity', 'notifier', function($scope, Score, ThingStats, $stateParams, identity, notifier) {
    $scope.identity = identity;
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            updateCanEditScore();
            getThingStats();
        },
        function errorGet() {
            $scope.notFound = true;
        });

    $scope.$watch('identity.userId', function(val) {
        updateCanEditScore();
    });

    function updateCanEditScore() {
        if($scope.score) {
            $scope.canEditScore = (identity.userId == $scope.score.user.id);
        } else {
            $scope.canEditScore = false;
        }
    }

    function getThingStats() {
        if(!$scope.score.thing) return;

        ThingStats.get($scope.score.thing.id).then(
            function successGetThingStats(thingStats) {
                $scope.thingStats = thingStats;
                console.log($scope.thingStats);
            },
            function errorGetThingStats(response) {
                console.error(response);
            });
    }

    $scope.updatePoints = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                $scope.score = updatedScore;
                $scope.updatePointsForm.$setPristine();
                notifier.success('updated points to ' + updatedScore.points);
                getThingStats($scope.score.thing);
            },
            function errorUpdate(response) {
                notifier.error('failed to update points');
                console.error(response);
            }
        )
    };

    $scope.getThingStats = getThingStats;
}]);
