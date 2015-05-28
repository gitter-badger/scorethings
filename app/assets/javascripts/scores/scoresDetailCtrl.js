angular.module('app').controller('ScoresDetailCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreModalFactory', '$modal', 'User', function($scope, $stateParams, Score, notifier, identity, scoreModalFactory, $modal, User) {
    $scope.isOwner = false;
    $scope.score = {};


    Score.get($stateParams.scoreId).then(
        function successGet(score) {
            $scope.isOwner = (identity.userId == score.user.id);
            console.log(score);
            $scope.score = score;
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });

    $scope.editScore = function() {
        scoreModalFactory.openModal($scope.score, {closeOnSave: true}, function saveSuccessCallbackFn(response) {
            $scope.score = response;
        });
    };

    $scope.share = function() {

    };

    $scope.deleteScore = function() {
    };

    function scoreListUpdateHandler(scoreList) {
        $scope.scoreList = scoreList;
    }

    $scope.showScoreListsModal = function() {
        $modal.open({
            templateUrl: 'scores/scoreListsModal.html',
            size: 'md',
            resolve: {
                score: function() {
                    return $scope.score;
                },
                scoreListUpdateHandler: function() {
                    return scoreListUpdateHandler;
                }
            },
            // TODO add array style controller def or move into seperate file
            controller: function scoreListsModalCtrl($scope, $modalInstance, ScoreListScore, score, scoreListUpdateHandler, newScoreListModalFactory) {
                User.get(identity.userId).then(
                    function successGettingCurrentUserScoreLists(currentUser) {
                        // TODO optimize so whole user isn't retrieved
                        $scope.scoreLists = currentUser.scoreLists;
                    }, function errorGettingCurrentUserScoreLists() {
                        notifier.error('failed to load current user score lists');
                        return;
                    });

                $scope.close = function() {
                    $modalInstance.dismiss();
                };

                $scope.score = score;

                $scope.createNewScoreList = function() {
                    newScoreListModalFactory.openModal(function scoreListCreatedCallback() {
                        User.get(identity.userId).then(
                            // TODO optimize so whole user isn't retrieved
                            function successGettingCurrentUserScoreLists(currentUser) {
                                $scope.scoreLists = currentUser.scoreLists;
                            }, function errorGettingCurrentUserScoreLists() {
                                notifier.error('failed to load current user score lists');
                            });
                    });
                };

                $scope.addScoreToScoreList = function(scoreList, index) {
                    new ScoreListScore({
                        scoreListId: scoreList.token,
                        scoreId: $scope.score.token
                    }).add()
                        .then(
                        function(updatedScoreList) {
                            $scope.scoreLists[index] = updatedScoreList;
                            notifier.success('added score to score list: ' + updatedScoreList.name);
                            scoreListUpdateHandler(updatedScoreList);
                        },
                        function(response) {
                            notifier.error('failed to created score');
                            console.log(response);
                        });
                };

                $scope.removeScoreFromScoreList = function(scoreList) {
                    new ScoreListScore({
                        scoreListId: scoreList.token,
                        scoreId: $scope.score.token
                    }).remove()
                        .then(
                        function(updatedScoreList) {
                            $scope.scoreLists[index] = updatedScoreList;
                            notifier.success('removed score from score list: ' + updatedScoreList.name);
                            scoreListUpdateHandler(updatedScoreList);
                        },
                        function(response) {
                            notifier.error('failed to created score');
                            console.log(response);
                        });
                };
            }
        });

    };
}]);