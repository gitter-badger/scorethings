angular.module('app').controller('ThingsDetailCtrl', ['$scope', '$stateParams', 'Thing', 'notifier', 'scoreModalFactory', '$state', function($scope, $stateParams, Thing, notifier, scoreModalFactory, $state) {
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
        $scope.scoreThisThing = function() {
            var scoreInput = {thing: $scope.thing};
            scoreModalFactory.openModal(scoreInput,
                function saveSuccessCallbackFn(createdScore) {
                    console.log(createdScore);
                    notifier.success('you scored the thing: ' + $scope.thing.title);
                    $state.go('scores.show', {scoreId: createdScore.token});
                },
                function(response) {
                    notifier.error('failed to score the thing: ' + $scope.thing.title);
                    return;
                });
        };
    };
}]);