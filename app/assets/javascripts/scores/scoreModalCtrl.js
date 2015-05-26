angular.module('app').controller('ScoreModalCtrl', ['$scope', '$modalInstance', 'ThingScore', 'Score', 'scoreInput', 'scoreCategoriesInput', 'saveSuccessCallbackFn', 'options', 'notifier', function($scope, $modalInstance, ThingScore, Score, scoreInput, scoreCategoriesInput, saveSuccessCallbackFn, options, notifier) {
    $scope.score = angular.extend({}, scoreInput);
    $scope.scoreCategories = scoreCategoriesInput;

    if(!$scope.score.id && !$scope.score.scoreCategoryId) {
        // initialize new score to have score category general selected
        // TODO this may need to be done outside of modal, in method call to
        // open modal
        $scope.score.scoreCategory = $scope.scoreCategories.general;
        $scope.score.scoreCategoryId = $scope.scoreCategories.general.id;
    }

    $scope.EDITING = 'EDITING';
    $scope.SAVED = 'SAVED';

    $scope.status = $scope.EDITING;

    $scope.cancel = function() {
        $modalInstance.dismiss('dismissed via cancel');
    };

    $scope.close = function() {
        $modalInstance.dismiss('dismissed via close');
    };

    $scope.save = function() {
        if(!$scope.score.id) {
            // we know we are creating a new score, because the score has no id,
            // so it's not in the database yet
            return createNewScore();
        } else {
            new Score($scope.score).update().then(function (updatedScore) {
                    notifier.success('saved score: ' + updatedScore.thing.title);
                    console.log(updatedScore);
                    $scope.score = updatedScore;
                    return handleSavedScore(updatedScore);
                },
                function() {
                    return notifier.error('failed to created score');
                });
        }
    };

    function handleSavedScore(score) {
        $scope.status = $scope.SAVED;
        $scope.score = score;
        saveSuccessCallbackFn(score);
        if(options.closeOnSave) {
            $scope.close();
        }
    }

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
                        return handleSavedScore(createdScore);
                    },
                    function() {
                        notifier.error('failed to created score');
                    });

        } else {
            return console.log('UNIMPLEMENTED:  HANDLE CREATING SCORE WITH KNOWN THINGID');
        }
    }
}]);