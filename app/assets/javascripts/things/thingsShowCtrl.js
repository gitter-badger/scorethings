angular.module('app').controller('ThingsShowCtrl', ['$scope', '$stateParams', 'Thing', 'WikidataItem', function($scope, $stateParams, Thing, WikidataItem) {
    var wikidataItemId = $stateParams.wikidataItemId;

    var NOT_FOUND_STATUS = 404;

    Thing.get(wikidataItemId).then(
        function successfulGetThing(thing) {
            $scope.onlyInWikidata = false;
            $scope.officialWebsites = thing.officialWebsites;
            $scope.title = thing.title;
            $scope.description = thing.description;

            $scope.score.thing.wikidataItemId = thing.wikidataItemId;
        },
        function unsuccessfulGetThing(response) {
            if(response.status == NOT_FOUND_STATUS) {
                WikidataItem.get(wikidataItemId).then(
                    function successfulGetWikidataPage(wikidataItem) {
                        $scope.onlyInWikidata = true;
                        $scope.wikidataItemId = wikidataItem.wikidataItemId;
                        $scope.officialWebsites = wikidataItem.officialWebsites;
                        $scope.title = wikidataItem.title;
                        $scope.description = wikidataItem.description;

                        $scope.score.thing.wikidataItemId = wikidataItem.id;
                    },
                    function unsuccessfulGetWikidataPage(response) {
                        console.error('failed to get wikidata item');
                    }
                );
            }
        });
}]);