angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', 'Stats', '$stateParams', 'identity', 'notifier', '$modal', function($scope, Score, Stats, $stateParams, identity, notifier, $modal) {
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
        $scope.thingCriterionStats = {};
        var criterionId = $scope.score.criterion && $scope.score.criterion.id;

        $scope.statsTitle = "All Scores For " + $scope.score.thing.title;
        if(criterionId) {
            $scope.statsTitle += " Using " + $scope.score.criterion.name;
        }


        Stats.query({thingId: $scope.score.thing.id, criterionId: criterionId}).then(function(stats) {
            console.log(stats);
            $scope.thingCriterionStats = stats;
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

    $scope.showScoreHistoryModal = function() {
        $modal.open({
            templateUrl: 'scores/scoreHistory.html',
            controller: ['$scope', '$modalInstance', 'score', function($scope, $modalInstance, score) {
                $scope.score = score;

                $scope.cancel = function() {
                    $modalInstance.dismiss('cancel');
                };
            }],
            size: 'md',
            resolve: {
                score: function() {
                    return $scope.score;
                }
            }
        });
    };

    $scope.getDeleteConfirmation = function() {
    };

    function deleteScore() {

    }

    $scope.getStats = getStats;
}]);
