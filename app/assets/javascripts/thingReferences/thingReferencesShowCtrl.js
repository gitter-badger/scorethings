angular.module('app').controller('ThingReferencesShowCtrl', ['$scope', '$stateParams', 'ThingReference', 'notifier', 'scoreModalFactory', '$state', function($scope, $stateParams, ThingReference, notifier, scoreModalFactory, $state) {
    var thingReferenceId = $stateParams.thingReferenceId;

    ThingReference.get(thingReferenceId).then(
        function successGet(thingReference) {
            $scope.thingReference = thingReference;
            $scope.thing = thingReference.thing;
            console.log(thingReference.user)
        },
        function errorGet(response) {
            notifier.error('failed to get thing_reference');
            console.log(response);
        });

    $scope.scoreThisThing = function() {
        scoreModalFactory.createNewScoreForThing($scope.thingReference, $scope.thing,
            function saveSuccessCallbackFn(createdScore) {
                notifier.success('you scored the thing: ' + $scope.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function saveErrorCallbackFn() {
                notifier.error('failed to score the thing: ' + $scope.thing.title);
                return;
            });
    };
}]);