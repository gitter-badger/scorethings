angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'WikidataItem', function($scope, WikidataItem) {
    $scope.notFound = false;
    $scope.query = '';

    $scope.search = function() {
        $scope.notFound = false;
        delete $scope.searchResults;

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
    };
}]);