angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'Thing', '$location', '$state', function($scope, Thing, $location, $state) {
    $scope.notFound = false;

    $scope.query = $state.params.query;
    if(!!$scope.query) {
        search();
    }


    function search() {
        $scope.notFound = false;
        delete $scope.searchResults;

        $location.search({query: $scope.query});

        Thing.get('search', {query: $scope.query}).then(
            function successfulGetThing(response) {
                $scope.searchResults = response.searchResults;
                $scope.notFound = !$scope.searchResults.length;
            },
            function unsuccessfulGetThing(response) {
                if(response.status == 404) {
                    $scope.notFound = true;
                }
            }
        );
    }

    $scope.search = search;
}]);