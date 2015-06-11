angular.module('app').controller('ThingCtrl', ['$scope', 'Thing', '$http', 'createNewScoreModalFactory', 'imageSearch', function($scope, Thing, $http, createNewScoreModalFactory, imageSearch) {
    $scope.imageUrls = [];

    imageSearch.search($scope.thing.label, function(imageUrls) {
        $scope.imageUrls = imageUrls;
    });

    $scope.scoreThisThing = function() {
        createNewScoreModalFactory.createNewScoreForThing($scope.thingReference, $scope.thing, $scope.imageUrls,
            function saveSuccessCallbackFn(createdScore) {
                notifier.success('you scored the thing: ' + $scope.thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function saveErrorCallbackFn() {
                notifier.error('failed to score the thing: ' + $scope.thing.title);
                return;
            });
    };
}]);