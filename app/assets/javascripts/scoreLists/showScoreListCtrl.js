angular.module('app').controller('ShowScoreListCtrl', ['$scope', '$routeParams', 'ScoreList', 'notifier', function($scope, $routeParams, ScoreList, notifier) {
    var scoreListId = $routeParams.scoreListId;

    ScoreList.one(scoreListId).get().then(
        function successGet(response) {
            $scope.scoreList = response.score_list;
        },
        function errorGet(response) {
            notifier.error('failed to get scoreList');
            console.log(response);
        });
}]);