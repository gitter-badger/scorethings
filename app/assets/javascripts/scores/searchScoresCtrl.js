angular.module('app').controller('ScoresSearchCtrl', ['$scope', 'Score', '$location', '$state', function($scope, Score, $location, $state) {
    $scope.notFound = false;
    console.log($state.params);
    $scope.query = $state.params.query;
    if(!!$scope.query) {
        search();
    }

    function search() {
        $scope.notFound = false;
        delete $scope.searchResults;

        $location.search({query: $scope.query});

        Score.get('search', {query: $scope.query}).then(
            function successfulSearchScore(scores) {
                $scope.scores = scores;
                $scope.notFound = !$scope.scores;
            },
            function unsuccessfulSearchScore(response) {
                $scope.notFound = true;
            }
        );
    }

    $scope.search = search;
}]);
