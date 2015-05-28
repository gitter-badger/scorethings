angular.module('app').controller('ThingsDetailCtrl', ['$scope', '$stateParams', 'Thing', 'notifier', 'scoreModalFactory', '$state', function($scope, $stateParams, Thing, notifier, scoreModalFactory, $state) {
    var thingId = $stateParams.thingId;

    Thing.get(thingId).then(
        function successGet(thing) {
            $scope.thing = thing;
        },
        function errorGet(response) {
            notifier.error('failed to get thing');
            console.log(response);
        });

    $scope.scoreThisThing = function() {
        var newScoreForThisThing = {
            thing: $scope.thing,
            thingId: $scope.thing.token
        };
        scoreModalFactory.openModal(newScoreForThisThing, {closeOnSave: true}, function saveSuccessCallbackFn(score) {
            notifier.success('you scored this thing');
            $state.go('scores.detail', {scoreId: score.token});
        });
    };
}]);