angular.module('app').controller('WikidataItemsShowCtrl', ['$scope', '$stateParams', 'Thing', 'WikidataItem', 'notifier', function($scope, $stateParams, Thing, WikidataItem, notifier) {
    var wikidataItemId = $stateParams.wikidataItemId;

    WikidataItem.get(wikidataItemId).then(
        function successfulGetWikidataPage(wikidataItem) {
            $scope.wikidataItem = wikidataItem;
        },
        function unsuccessfulGetWikidataPage(response) {
            console.error('failed to get wikidata item');
            if(response.status == 409) {
                notifier.error('could not find wikidata item');
            }
        }
    );
}]);