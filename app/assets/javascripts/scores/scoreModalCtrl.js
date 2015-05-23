angular.module('app').controller('ScoreModalCtrl', ['$scope', '$modalInstance', 'ThingScore', 'Score', 'scoreInput', 'scoreCategoriesInput', 'notifier', function($scope, $modalInstance, ThingScore, Score, scoreInput, scoreCategoriesInput, notifier) {
    $scope.scoreCategories = scoreCategoriesInput;

    $scope.EDITING = 'EDITING';
    $scope.SAVED = 'SAVED';

    $scope.status = $scope.EDITING;

    $scope.score = angular.extend(scoreInput, {});

    $scope.save = function() {
        if(!$scope.score.id) {
            // we know we are creating a new score, because the score has no id,
            // so it's not in the database yet
            return createNewScore();
        } else {
            new Score($scope.score).update().then(function (response) {
                    var updatedScore = response.score;
                    notifier.success('saved score: ' + updatedScore.thing.title);
                    console.log(updatedScore);
                    $scope.score = updatedScore;
                    return $scope.status = $scope.SAVED;
                },
                function () {
                    return notifier.error('failed to created score');
                });
        }
    };

    $scope.cancel = function() {
        $modalInstance.dismiss('dismissed via cancel');
    };

    $scope.close = function() {
        $modalInstance.dismiss('dismissed via close');
    };

    function createNewScore() {
        if(!$scope.score.thing.id) {
            // which means you know the thing is in scorethings' database
            new ThingScore({
                externalId: $scope.score.thing.externalId,
                thingType: $scope.score.thing.type,
                score: $scope.score
            }).create()
                .then(
                function(response) {
                    var createdScore = response.score;
                    notifier.success('created score for thing: ' + createdScore.thing.title);
                    console.log(createdScore);
                    $scope.score = createdScore;
                    $scope.status = $scope.SAVED;
                },
                function() {
                    notifier.error('failed to created score');
                });

        } else {
            return console.log('UNIMPLEMENTED:  HANDLE CREATING SCORE WITH KNOWN THINGID');
        }
    }
}]);