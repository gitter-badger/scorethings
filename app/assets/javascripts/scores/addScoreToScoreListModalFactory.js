angular.module('app').factory('addScoreToScoreListModalFactory', ['$modal', function($modal) {
    return {
        openModal: function(scoreListInput, options, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scoreLists/addScoreToScoreListModal.html',
                size: 'md',
                resolve: {
                    scoreListInput: function() {
                        return scoreListInput;
                    },
                    saveSuccessCallbackFn: function() {
                        return saveSuccessCallbackFn;
                    },
                    options: function() {
                        return options;
                    }
                },
                controller: ['$scope', '$modalInstance', 'Score', 'ScoreListScore', 'scoreListInput', 'saveSuccessCallbackFn', 'options', 'notifier',
                    function($scope, $modalInstance, Score, ScoreListScore, scoreListInput, saveSuccessCallbackFn, options, notifier) {
                    $scope.query = '';
                    $scope.scores = [];
                    $scope.showNoResultsMessage = false;

                    $scope.scoreList = angular.extend({}, scoreListInput);

                    $scope.cancel = function() {
                        $modalInstance.dismiss('dismissed via cancel');
                    };

                    $scope.close = function() {
                        $modalInstance.dismiss('dismissed via close');
                    };

                    $scope.search = function() {
                        $scope.scores = [];

                        $scope.showNoResultsMessage = false;

                        Score.get('search', {user_id: $scope.scoreList.user.id, query: $scope.query}).then(
                            function success(scores) {
                                $scope.scores = scores;
                                if (!$scope.scores.length) {
                                    $scope.showNoResultsMessage = true;
                                }
                            },
                            function error(response) {
                                notifier.error('failed to search for scores');
                                console.error(response);
                                $scope.showNoResultsMessage = true;
                            });
                    };

                    $scope.addScoreToScoreList = function(score) {
                        new ScoreListScore({
                            scoreListId: $scope.scoreList.token,
                            scoreId: score.token
                        }).add()
                            .then(
                            function(updatedScoreList) {
                                notifier.success('created score to score list');
                                saveSuccessCallbackFn(updatedScoreList);
                                $scope.close();
                            },
                            function(response) {
                                notifier.error('failed to created score');
                                console.log(response);
                            });
                    };

                }]
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);