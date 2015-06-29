angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', 'Stats', '$stateParams', 'identity', 'notifier', '$modal', 'shareScoreModalFactory', '$state', function($scope, Score, Stats, $stateParams, identity, notifier, $modal, shareScoreModalFactory, $state) {
    $scope.identity = identity;
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
            getStats();
            updateIsEditable();
        },
        function errorGet() {
            $scope.notFound = true;
        });

    $scope.$watch('identity.userId', function(val) {
        updateIsEditable();
    });

    function updateIsEditable() {
        if($scope.score) {
            $scope.isEditable = (identity.userId == $scope.score.user.id);
        } else {
            $scope.isEditable = false;
        }
    }

    function getStats() {
        $scope.thingCriterionStats = {};
        var criterionId = $scope.score.criterion && $scope.score.criterion.id;

        $scope.statsTitle = "All Scores For " + $scope.score.scoredThing.title;
        if(criterionId) {
            $scope.statsTitle += " Using " + $scope.score.criterion.name;
        }


        Stats.query({scoredThingId: $scope.score.scoredThing.id, criterionId: criterionId}).then(function(stats) {
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

    $scope.showScorePointsHistoryModal = function() {
        $modal.open({
            templateUrl: 'scores/pointsHistory.html',
            controller: ['$scope', '$modalInstance', 'score', function($scope, $modalInstance, score) {
                $scope.score = score;

                $scope.close = function() {
                    $modalInstance.dismiss('close');
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

    $scope.share = function() {
        shareScoreModalFactory.shareCreatedScore($scope.score);
    };

    $scope.askForDeleteConfirmation = function() {
        var modalInstance = $modal.open({
                templateUrl: 'scores/confirmDeleteScoreModal.html',
                controller: ['$scope', '$modalInstance', function($scope, $modalInstance) {
                    $scope.cancel = function() {
                        $modalInstance.dismiss('cancel');
                    };

                    $scope.confirm = function() {
                        $modalInstance.close('confirm');
                    };
                }],
                size: 'md',
                resolve: {
                    score: function() {
                        return $scope.score;
                    }
                }
            });

        modalInstance.result.then(function confirmedDeleteScore() {
            new Score($scope.score).delete().then(
                function deleteSuccessful() {
                    notifier.success('successfully deleted score');
                    $state.go('home');
                }, function deleteError() {
                    console.error('failed to delete score');
                });
        });
    };
}]);
