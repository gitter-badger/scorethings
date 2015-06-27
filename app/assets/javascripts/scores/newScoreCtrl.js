angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'WikidataItem', 'Score', '$modal', '$state', '$rootScope', function($scope, $location, WikidataItem, Score, $modal, $state, $rootScope) {
    var wikidataItemId = $state.params.wikidataItemId;
    var criterionNameParam = $state.params.criterion;
    var criterionFromParam = null;


    if(criterionNameParam) {
        // FIXME is there a way to avoid this waiting for criteria data to come from server?
        $scope.$watch('criteria', function(criteria) {
            angular.forEach(criteria, function(criterion) {
                if(criterion.name == criterionNameParam) {
                    selectCriterion(criterion);
                    return;
                }
            });

        });
    }

    $scope.score = {
        points: 7,
        criterion: criterionFromParam,
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
            controller: ['$scope', '$modalInstance', 'criteria', 'selectedCriterion', function($scope, $modalInstance, criteria, selectedCriterion) {
                $scope.criteria = criteria;
                $scope.selectedCriterionId = selectedCriterion && selectedCriterion.id;

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

        modalInstance.result.then(
            function dismiss(criterion) {
                selectCriterion(criterion);
            },
            function close() {
            });
    };

    function selectCriterion(criterion) {
        $scope.score.criterion_id = criterion && criterion.id;
        $scope.score.criterion = criterion;
        $state.params.criterion = criterion && criterion.name;
        $location.search($state.params);
    }
}]);