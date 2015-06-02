angular.module('app').controller('CreateNewScoreModalCtrl', ['thingInput', '$scope', '$modalInstance', 'Score', 'Thing', 'notifier', function(thingInput, $scope, $modalInstance, Score, Thing, notifier) {
    $scope.score = {
        thing: thingInput
    };

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        if($scope.score.thing.id) {
            $scope.score.thing_id = $scope.score.thing.id;
            return createNewScore();
        } else {
            new Thing({type: $scope.score.thing.webThing.type, externalId: $scope.score.thing.webThing.externalId})
                .create().then(
                    function successCreateThing(thing) {
                        $scope.score.thing_id = thing.id;
                        return createNewScore();
                    },
                    function errorCreateThing(response) {
                        console.log(response);
                        return notifier.error('failed to score thing: ' + $scope.score.thing.webThing.title);
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
