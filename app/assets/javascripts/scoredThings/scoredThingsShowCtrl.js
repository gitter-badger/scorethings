angular.module('app').controller('ScoredThingsShowCtrl', ['$scope', '$stateParams', 'ScoredThing', 'notifier', function($scope, $stateParams, ScoredThing, notifier) {
    var scoredThingId = $stateParams.scoredThingId;

    ScoredThing.get(scoredThingId).then(
        function successfulGetScoredThing(scoredThing) {
            $scope.scoredThing = scoredThing;
        },
        function unsuccessfulGetScoredThing(response) {
            notifier.error('failed to get scored thing');
        });
}]);