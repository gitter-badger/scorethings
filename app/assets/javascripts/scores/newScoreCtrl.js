angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'WikidataItem', 'Score', function($scope, $location, WikidataItem, Score) {
    var wikidataItemId = $location.search()['wikidataItemId'];
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
        },
        function unsuccessfulGetWikidataPage(response) {
            console.error('failed to get wikidata item');
            // TODO redirect/show error message
        }
    );

    $scope.save = function() {
        new Score($scope.score).create(
            function successCreate(score) {
                console.log(score);
            },
            function errorCreate(response) {

            });
    };
}]);