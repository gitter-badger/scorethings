angular.module('app').controller('ScoresSearchCtrl', ['$scope', '$stateParams', 'ScoreSearch', 'notifier', function($scope, $stateParams, ScoreSearch, notifier) {
    $scope.searchForScores = function() {
        ScoreSearch.query({query: $scope.query}).then(function(scores) {
            $scope.scores = scores;
        }, function() {
            notifier.error('failed to search for scores');
            return;
        });
    };
}]);
