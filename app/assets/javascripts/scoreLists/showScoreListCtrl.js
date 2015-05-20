angular.module('app').controller('ShowScoreListCtrl', ['$scope', '$routeParams', 'ScoreList', 'notifier', function($scope, $routeParams, ScoreList, notifier) {
    var scoreListId = $routeParams.scoreListId;

    ScoreList.get(scoreListId).then(function(scoreList) {
       $scope.scoreList = scoreList;
    }, function(resp) {
        console.log(resp);
    });
}]);