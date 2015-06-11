angular.module('app').controller('ScoreThingCtrl', ['$scope', 'Thing', 'createNewScoreModalFactory', 'notifier', '$stateParams', '$state', '$location', function($scope, Thing, createNewScoreModalFactory, notifier, $stateParams, $state, $location) {
    $scope.showNoResultsMessage = false;

    $scope.$watch('query', function() {
        $scope.showNoResultsMessage = false;
    });

    $scope.searchThings = function() {
        $scope.things = [];

        if(!$scope.query.length) return;

        $location.search({
            query: $scope.query
        });

        $scope.showNoResultsMessage = false;

        Thing.get('search', {query: $scope.query})
            .then(function(response) {
                $scope.things = response.searchResults;
                if(!$scope.things || !$scope.things.length) {
                    $scope.showNoResultsMessage = true;
                }
            });
    }
}]);