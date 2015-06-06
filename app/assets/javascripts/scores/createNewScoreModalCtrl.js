angular.module('app').controller('CreateNewScoreModalCtrl', ['thingReferenceInput', 'thingInput', '$scope', '$modalInstance', 'Score', 'ThingReference', 'notifier', 'settingsStorage', function(thingReferenceInput, thingInput, $scope, $modalInstance, Score, ThingReference, notifier, settingsStorage) {
    $scope.settings = settingsStorage.get();

    $scope.score = {
        thingReferenceId: thingReferenceInput && thingReferenceInput.id,
        points: $scope.settings.defaultPoints || 75,
        good: $scope.settings.defaultGood || 75
    };

    $scope.warningMessage = null;

    $scope.thing = thingInput;

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        if($scope.score.thingReferenceId) {
            return createNewScore();
        } else {
            // if the score doesn't already have a thing reference id from the inputs,
            // create a new one
            // TODO this might be confusing, this controller is being used for
            // when the thing reference is known (on the thing reference show view score buttton)
            // and also when scoring a thing search result
            // maybe split into seperate controllers
            new ThingReference({type: $scope.thing.type, externalId: $scope.thing.externalId})
                .create().then(
                    function successCreateThingReference(thingReference) {
                        $scope.score.thingReferenceId = thingReference.id;
                        return createNewScore();
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

    function createNewScore() {
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
