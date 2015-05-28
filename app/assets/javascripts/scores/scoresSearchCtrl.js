angular.module('app').controller('ScoresSearchCtrl', ['$scope', '$stateParams', 'ScoreSearch', 'notifier', '$location', function($scope, $stateParams, ScoreSearch, notifier, $location) {
    function searchForScores() {
        $location.search({query: $scope.query});
        ScoreSearch.query({query: $scope.query}).then(function(scores) {
            $scope.scores = scores;
        }, function() {
            notifier.error('failed to search for scores');
            return;
        });
    }

    var params = $location.$$search;

    if(params) {
        $scope.query = params.query;
        if(params.query) {
            searchForScores();
        }
    }

    $scope.searchForScores = searchForScores;
}]);
