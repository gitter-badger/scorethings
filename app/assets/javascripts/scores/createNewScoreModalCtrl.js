angular.module('app').controller('CreateNewScoreModalCtrl', ['thingReferenceInput', 'thingInput', 'imagesInput', '$scope', '$modalInstance', 'Score', 'ThingReference', 'notifier', function(thingReferenceInput, thingInput, imagesInput, $scope, $modalInstance, Score, ThingReference, notifier) {
    var DEFAULT_POINTS = 70;

    $scope.score = {
        thingReferenceId: thingReferenceInput && thingReferenceInput.id,
        points: DEFAULT_POINTS
    };

    $scope.warningMessage = null;

    $scope.thing = thingInput;
    $scope.imagesInput = imagesInput;

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        if($scope.score.thingReferenceId) {
            return createNewScoreWithExistingThingReference();
        } else {
            new ThingReference({dbpedia_uri: $scope.thing.uri})
                .create().then(
                    function successCreateThingReference(thingReference) {
                        $scope.score.thingReferenceId = thingReference.id;
                        return createNewScoreWithExistingThingReference();
                    },
                    function errorCreateThingReference(response) {
                        if(response.status == 409) {
                            handleConflict(response);
                        } else {
                            return notifier.error('failed to score thing_reference: ' + $scope.thing.title);
                        }
                    });
        }
    };

    $scope.changeExistingScore = function() {
        // TODO it might be easier to just send the user to the score to change it,
        // rather than having two ways to change it
        if(!$scope.existingScoreId) {
            notifier.error('there was a problem updating your previous score');
            return;
        }

        $scope.score.id = $scope.existingScoreId;
        new Score($scope.score).update().then(function successUpdate(score) {
            $modalInstance.close(score);
        }, function errorUpdate() {
            return notifier.error('failed to score thing: ' + $scope.thing.title);
        });
    };

    function handleConflict(response) {
        // there was a conflict because a score with the same user and thing_reference
        // already exists, so ask user if they want to update it
        $scope.scoreConflictMessage = 'Sorry, you already have a score for this thing.';

        $scope.existingScoreId = response.data.existing_score.token;
    }

    function createNewScoreWithExistingThingReference() {
        new Score($scope.score).create().then(function successCreate(score) {
                $modalInstance.close(score);
            }, function errorCreate(response) {
                if(response.status == 409) {
                    handleConflict(response);
                } else {
                    return notifier.error('failed to score thing: ' + $scope.thing.title);
                }
            });
    }
}]);
