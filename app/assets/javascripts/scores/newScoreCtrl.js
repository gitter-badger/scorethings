angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'WikidataItem', 'Score', '$modal', '$state', function($scope, $location, WikidataItem, Score, $modal, $state) {
    var wikidataItemId = $location.search()['wikidataItemId'];

    $scope.score = {
        points: 7,
        criterion: null,
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
        console.log($scope.score);
        new Score($scope.score).create().then(
            function successCreate(score) {
                console.log(score);
                $state.go('scores.show', {scoreId: score.token});
            },
            function errorCreate(response) {
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

    $scope.showCriterionSelectionModal = function() {
        var modalInstance = $modal.open({
            templateUrl: 'scores/selectCriterion.html',
            controller: ['$scope', '$modalInstance', 'criteria', function($scope, $modalInstance, criteria) {
                $scope.criteria = criteria;
                $scope.criteria_id = criteria.id;

                $scope.cancel = function() {
                    $modalInstance.dismiss('cancel');
                };

                $scope.selectCriterion = function(criterion) {
                    $modalInstance.close(criterion);
                };
            }],
            size: 'sm',
            resolve: {
                selectedCriterion: function() {
                    return $scope.score.criterion;
                },
                criteria: function() {
                    return $scope.criteria;
                }
            }
        });

        modalInstance.result.then(function (criterion) {
            console.log(criterion)
            $scope.score.criterion_id = criterion.id;
            $scope.score.criterion = criterion;
        }, function () {

        });
    };
}]);