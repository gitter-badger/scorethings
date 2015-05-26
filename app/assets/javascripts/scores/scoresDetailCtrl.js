angular.module('app').controller('ScoresDetailCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreModalFactory', function($scope, $stateParams, Score, notifier, identity, scoreModalFactory) {
    var scoreId = $stateParams.scoreId;

    $scope.identity = identity;

    Score.get(scoreId).then(
        function successGet(score) {
            console.log(score);
            $scope.score = score;
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });

    $scope.editScore = function() {
        scoreModalFactory.openModal($scope.score, {closeOnSave: true}, function saveSuccessCallbackFn(response) {
            console.log('save success');
            console.log(response);
            $scope.score = response;
        });
    };
}]);