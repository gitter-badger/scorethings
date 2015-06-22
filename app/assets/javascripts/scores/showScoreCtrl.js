angular.module('app').controller('ShowScoreCtrl', ['$scope', 'Score', '$stateParams', function($scope, Score, $stateParams) {
    var scoreId = $stateParams.scoreId;
    $scope.notFound = false;

    Score.get(scoreId).then(
        function successGet(score) {
            $scope.score = score;
        },
        function errorGet() {
            $scope.notFound = true;
        });
}]);
