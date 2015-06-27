angular.module('app').controller('WikidataItemsSearchCtrl', ['$scope', 'WikidataItem', '$location', '$state', function($scope, WikidataItem, $location, $state) {
    $scope.notFound = false;

    $scope.query = $state.params.query;
    if(!!$scope.query) {
        search();
    }


    function search() {
        $scope.notFound = false;
        delete $scope.searchResults;

        $location.search({query: $scope.query});

        WikidataItem.get('search', {query: $scope.query}).then(
            function successfulGetWikidataItem(response) {
                $scope.searchResults = response.searchResults;
                $scope.notFound = !$scope.searchResults;
            },
            function unsuccessfulGetWikidataItem(response) {
                if(response.status == 404) {
                    $scope.notFound = true;
                }
            }
        );
    }

    $scope.search = search;
}]);