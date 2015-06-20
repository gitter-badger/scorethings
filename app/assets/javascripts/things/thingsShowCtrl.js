angular.module('app').controller('ThingsShowCtrl', ['$scope', '$stateParams', 'Thing', 'WikipediaPage', function($scope, $stateParams, Thing, WikipediaPage) {
    var wikipediaPageName = $stateParams.wikipediaPageName;

    var NOT_FOUND_STATUS = 404;
    $scope.fromWikipediaPage = true;

    Thing.get(wikipediaPageName).then(
        function successfulGetThing(thing) {
            $scope.fromWikipediaPage = true;
            $scope.title = thing.title;
            $scope.fullUrl = thing.fullUrl;
            $scope.pageid = thing.pageid;
            $scope.imageUrls = thing.imageUrls;
            $scope.pageName = thing.pageName;
        },
        function unsuccessfulGetThing(response) {
            if(response.status == NOT_FOUND_STATUS) {
                WikipediaPage.get(wikipediaPageName).then(
                    function successfulGetWikipediaPage(wikipediaPage) {
                        console.log(wikipediaPage)
                        $scope.fromWikipediaPage = true;
                        $scope.title = wikipediaPage.title;
                        $scope.fullUrl = wikipediaPage.fullUrl;
                        $scope.pageid = wikipediaPage.pageid;
                        $scope.imageUrls = wikipediaPage.imageUrls;
                        $scope.pageName = wikipediaPage.pageName;
                        $scope.categories = wikipediaPage.categories;
                    },
                    function unsuccessfulGetWikipediaPage(response) {
                        console.error('failed to get dbpedia thing');
                    }
                );
            }
        });
}]);