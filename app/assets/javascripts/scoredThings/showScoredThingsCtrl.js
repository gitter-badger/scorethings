angular.module('app').controller('ShowScoredThingsCtrl', ['$scope', '$stateParams', 'ScoredThing', 'ScoredThingScores', 'notifier', 'Stats', '$state', function($scope, $stateParams, ScoredThing, ScoredThingScores, notifier, Stats, $state) {
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

    ScoredThingScores.get({scoreThingId: scoredThingId}).then(
        function successfulGetScoreThingScoresScores(scores) {
            $scope.scores = scores;
        },
        function unsuccessfulGetScoreThingScoresScores(response) {
            notifier.error('failed to get scored thing scores');
            console.error(response);
        });
}]);