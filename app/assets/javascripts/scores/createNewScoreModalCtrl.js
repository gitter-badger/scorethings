angular.module('app').controller('CreateNewScoreModalCtrl', ['thingInput', 'webThingInput', '$scope', '$modalInstance', 'Score', 'ThingReference', 'notifier', 'settingsStorage', function(thingInput, webThingInput, $scope, $modalInstance, Score, ThingReference, notifier, settingsStorage) {
    $scope.settings = settingsStorage.get();

    $scope.score = {
        thing_id: thingInput && thingInput.id,
        points: $scope.settings.defaultPoints || 75,
        goodPoint: $scope.settings.defaultGoodPoint || 75
    };

    $scope.warningMessage = null;

    $scope.webThing = webThingInput;

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        if($scope.score.thingReferenceId) {
            return createNewScore();
        } else {
            new ThingReference({type: $scope.webThing.type, externalId: $scope.webThing.externalId})
                .create().then(
                    function successCreateThingReference(thingReference) {
                        $scope.score.thingReferenceId = thingReference.id;
                        return createNewScore();
                    },
                    function errorCreateThingReference(response) {
                        if(response.status == 409) {
                            handleConflict(response);
                        } else {
                            return notifier.error('failed to score thing_reference: ' + $scope.webThing.title);
                        }
                    });
        }
    };

    $scope.changeExistingScore = function() {
        if(!$scope.existingScoreId) {
            notifier.error('there was a problem updating your previous score');
            return;
        }

        $scope.score.id = $scope.existingScoreId;
        new Score($scope.score).update().then(function successUpdate(score) {
            $modalInstance.close(score);
        }, function errorUpdate(response) {
            return notifier.error('failed to score thing: ' + $scope.webThing.title);
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
                console.log(score);
                $modalInstance.close(score);
            }, function errorCreate(response) {
                if(response.status == 409) {
                    handleConflict(response);
                } else {
                    return notifier.error('failed to score thing: ' + $scope.webThing.title);
                }
            });
    }
}]);
