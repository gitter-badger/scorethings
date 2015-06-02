angular.module('app').controller('CreateNewScoreModalCtrl', ['thingInput', 'webThingInput', '$scope', '$modalInstance', 'Score', 'Thing', 'notifier', function(thingInput, webThingInput, $scope, $modalInstance, Score, Thing, notifier) {
    $scope.score = {
        thing_id: thingInput && thingInput.id
    };

    $scope.webThing = webThingInput;

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        if($scope.score.thing_id) {
            return createNewScore();
        } else {
            new Thing({type: $scope.webThing.type, externalId: $scope.webThing.externalId})
                .create().then(
                    function successCreateThing(thing) {
                        $scope.score.thing_id = thing.id;
                        return createNewScore();
                    },
                    function errorCreateThing(response) {
                        console.log(response);
                        return notifier.error('failed to score thing: ' + $scope.webThing.title);
                    });
        }
    };

    function createNewScore() {
        new Score($scope.score).create().then(function successCreate(score) {
                console.log(score);
                $modalInstance.close(score);
            }, function errorCreate(errorMsg) {
                notifier.error('failed to save score: ' + errorMsg);
            });
    }
}]);
