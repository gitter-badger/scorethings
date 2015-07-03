angular.module('app').controller('ShowScoredThingsScoresCtrl', ['$scope', 'ScoredThingScores', 'notifier', '$stateParams', function($scope, ScoredThingScores, notifier, $stateParams) {
    var scoredThingId = $stateParams.scoredThingId;

    ScoredThingScores.get({scoreThingId: scoredThingId}).then(
        function successfulGetScoreThingScoresScores(scores) {
            $scope.scores = scores;
        },
        function unsuccessfulGetScoreThingScoresScores(response) {
            notifier.error('failed to get scored thing scores');
        });
}]);
