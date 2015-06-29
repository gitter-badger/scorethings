angular.module('app').controller('ShowScoredThingsCtrl', ['$scope', '$stateParams', 'ScoredThing', 'notifier', 'Stats', function($scope, $stateParams, ScoredThing, notifier, Stats) {
    var scoredThingId = $stateParams.scoredThingId;

    ScoredThing.get(scoredThingId).then(
        function successfulGetScoredThing(scoredThing) {
            $scope.scoredThing = scoredThing;

            Stats.query({scoredThingId: $scope.scoredThing.id}).then(function(stats) {
                $scope.scoredThingStats = stats;
            });
        },
        function unsuccessfulGetScoredThing(response) {
            notifier.error('failed to get scored thing');
        });
}]);