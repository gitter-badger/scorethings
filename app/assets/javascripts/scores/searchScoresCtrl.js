angular.module('app').controller('ScoresSearchCtrl', ['$scope', 'Score', '$location', '$state', function($scope, Score, $location, $state) {
    $scope.notFound = false;
    $scope.query = $state.params.query;
    if(!!$scope.query) {
        search();
    }

    function search() {
        $scope.notFound = false;
        delete $scope.searchResults;
        delete $scope.error;

        $location.search({query: $scope.query});

        Score.get('search', {query: $scope.query}).then(
            function successfulSearchScore(scores) {
                $scope.scores = scores;
                $scope.notFound = !$scope.scores;
            },
            function unsuccessfulSearchScore(response) {
                $scope.notFound = true;
                console.log(response);
                if(response.status == 404) {
                    // this could be because the username filter in response
                    // had no user
                    $scope.error = response.data.error;
                }
            }
        );
    }

    $scope.search = search;
}]);
