angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', 'Stats', '$stateParams', 'identity', 'notifier', function($scope, Score, Stats, $stateParams, identity, notifier) {
    $scope.identity = identity;
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            getStats();
            updateCanEditScore();
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

    function getStats() {
        $scope.userStats = {};
        $scope.userCriterionStats = {};
        $scope.thingStats = {};
        $scope.thingCriterionStats = {};

        var criterionId = $scope.score.criterion && $scope.score.criterion.id;

        if(!!criterionId) {
            // these stats have the criterionId filter
            // without the criterionId, they are redundant
            Stats.query({userId: $scope.score.user.id, criterionId: criterionId}).then(function(stats) {
                console.log(stats);
                $scope.userCriterionStats = stats;
            });
            Stats.query({thingId: $scope.score.thing.id, criterionId: criterionId}).then(function(stats) {
                console.log(stats);
                $scope.thingCriterionStats = stats;
            });
        }

        Stats.query({userId: $scope.score.user.id}).then(function(stats) {
            console.log(stats);
            $scope.userStats = stats;
        });

        Stats.query({thingId: $scope.score.thing.id}).then(function(stats) {
            console.log(stats);
            $scope.thingStats = stats;
        });
    }

    $scope.updatePoints = function() {
        new Score($scope.score).update().then(
            function successUpdate(updatedScore) {
                $scope.score = updatedScore;
                $scope.updatePointsForm.$setPristine();
                notifier.success('updated points to ' + updatedScore.points);
                getStats();
            },
            function errorUpdate(response) {
                notifier.error('failed to update points');
                console.error(response);
            }
        )
    };
}]);
