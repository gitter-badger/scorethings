angular.module('app').controller('ShowScoredThingsCtrl', ['$scope', '$stateParams', 'ScoredThing', 'notifier', 'Stats', '$state', function($scope, $stateParams, ScoredThing, notifier, Stats, $state) {
    var scoredThingId = $stateParams.scoredThingId;

    ScoredThing.get(scoredThingId).then(
        function successfulGetScoredThing(scoredThing) {
            $scope.scoredThing = scoredThing;

            $scope.scoredThingScoresUrl = $state.href('scoredThings.show.scores', {scoredThingId: $scope.scoredThing.token});

            Stats.query({scoredThingId: $scope.scoredThing.id}).then(function(stats) {
                $scope.scoredThingStats = stats;
            });
        },
        function unsuccessfulGetScoredThing(response) {
            notifier.error('failed to get scored thing');
        });
}]);