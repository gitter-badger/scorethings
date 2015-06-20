angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'WikipediaPage', function($scope, WikipediaPage) {
    $scope.notFound = false;
    $scope.title = '';

    $scope.search = function() {
        $scope.notFound = false;
        delete $scope.wikipediaPage;
        var wikipediaPageName = $scope.wikipediaPageTitle.replace(' ', '_');

        WikipediaPage.get(wikipediaPageName).then(
            function successfulGetWikipediaPage(wikipediaPage) {
                console.log(wikipediaPage);
                $scope.wikipediaPage = wikipediaPage;
            },
            function unsuccessfulGetWikipediaPage(response) {
                if(response.status == 404) {
                    $scope.notFound = true;
                }
            }
        );
    };
}]);