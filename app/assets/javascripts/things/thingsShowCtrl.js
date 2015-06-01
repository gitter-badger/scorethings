angular.module('app').controller('ThingsShowCtrl', ['$scope', '$stateParams', 'Thing', 'notifier', 'scoreModalFactory', '$state', function($scope, $stateParams, Thing, notifier, scoreModalFactory, $state) {
    var thingId = $stateParams.thingId;

    Thing.get(thingId).then(
        function successGet(thing) {
            $scope.thing = thing;
            console.log(thing.user)
        },
        function errorGet(response) {
            notifier.error('failed to get thing');
            console.log(response);
        });

    $scope.scoreThisThing = function() {
        scoreModalFactory.createNewScoreForThing($scope.thing,
            function saveSuccessCallbackFn(createdScore) {
                notifier.success('you scored the thing: ' + createdScore.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function(response) {
                notifier.error('failed to score the thing: ' + $scope.thing.webThing.title);
                return;
            });
    };
}]);