angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'WikidataItem', 'Score', '$modal', '$state', function($scope, $location, WikidataItem, Score, $modal, $state) {
    var wikidataItemId = $location.search()['wikidataItemId'];

    $scope.score = {
        points: 70,
        criterion: 'General',
        thing: {
            wikidataItemId: wikidataItemId
        }
    };

    WikidataItem.get(wikidataItemId).then(
        function successfulGetWikidataPage(wikidataItem) {
            $scope.wikidataItem = wikidataItem;
            $scope.score.thing.wikidataItemId = wikidataItem.id;
        },
        function unsuccessfulGetWikidataPage(response) {
            console.error('failed to get wikidata item');
            // TODO redirect/show error message
        }
    );

    $scope.save = function() {
        new Score($scope.score).create().then(
            function successCreate(score) {
                console.log(score);
                $state.go('scores.show', {scoreId: score.token});
            },
            function errorCreate(response) {
                console.log(response);
                if(response.status == 409) {
                    // conflict with existing score with same
                    // user, thing, and criterion
                    // TODO should ask user to confirm updating points?
                    response = humps.camelizeKeys(response);
                    var existingScore = response.data.existingScore;
                    existingScore.points = $scope.score.points;
                    new Score(existingScore).update().then(
                        function successUpdate(score) {
                            console.log(score);
                            $state.go('scores.show', {scoreId: score.token});
                        },
                        function errorUpdate(response) {
                            console.error(response);
                        }
                    )
                }
            });
    };

    $scope.selectACriterion = function() {
        var modalInstance = $modal.open({
            templateUrl: 'scores/selectCriterion.html',
            controller: ['$scope', '$modalInstance', 'scoreCriterion', 'validCriteria', function($scope, $modalInstance, scoreCriterion, validCriteria) {
                $scope.scoreCriterion = scoreCriterion;
                $scope.validCriteria = validCriteria;

                $scope.cancel = function() {
                    $modalInstance.dismiss('cancel');
                };

                $scope.selectCriterion = function(criterion) {
                    $modalInstance.close(criterion);
                };
            }],
            size: 'lg',
            resolve: {
                scoreCriterion: function() {
                    return $scope.score.criterion;
                },
                validCriteria: function() {
                    return $scope.validCriteria;
                }
            }
        });

        modalInstance.result.then(function (criterion) {
            $scope.score.criterion = criterion;
        }, function () {

        });
    };
}]);