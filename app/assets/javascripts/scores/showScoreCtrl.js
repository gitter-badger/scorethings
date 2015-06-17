angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', function($scope, Score) {
    var scoreId = $stateParams.scoreId;
    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
        },
        function errorGet() {
            $scope.notFound = true;
        });
}]);
