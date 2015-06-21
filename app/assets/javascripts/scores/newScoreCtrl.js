angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'WikidataItem', 'Score', 'imageSearch', function($scope, $location, WikidataItem, Score, imageSearch) {
    var wikidataItemId = $location.search()['wikidataItemId'];
    $scope.imageUrls = [];

    $scope.score = {
        points: 70,
        thing: {
            wikidataItemId: wikidataItemId
        }
    };

    WikidataItem.get(wikidataItemId).then(
        function successfulGetWikidataPage(wikidataItem) {
            $scope.wikidataItem = wikidataItem;
            $scope.score.thing.wikidataItemId = wikidataItem.id;
            var imageQuery = wikidataItem.title + ' ' + (wikidataItem.description || '');
            imageSearch.search(imageQuery, function(imageUrls) {
                $scope.imageUrls = imageUrls;
            });
        },
        function unsuccessfulGetWikidataPage(response) {
            console.error('failed to get wikidata item');
            // TODO redirect/show error message
        }
    );

    $scope.scoreThing = function() {
        new Score($scope.score).create(
            function successCreate(score) {
                console.log(score);
            },
            function errorCreate(response) {

            });
    };
}]);