angular.module('app').controller('ScoresDetailCtrl', ['$scope', '$stateParams', 'Score', 'notifier', 'identity', 'scoreModalFactory', '$modal', 'User', function($scope, $stateParams, Score, notifier, identity, scoreModalFactory, $modal, User) {
    $scope.isOwner = false;
    $scope.score = {};


    Score.get($stateParams.scoreId).then(
        function successGet(score) {
            $scope.isOwner = (identity.userId == score.user.id);
            console.log(score);
            $scope.score = score;
        },
        function errorGet(response) {
            notifier.error('failed to get score');
            console.log(response);
        });

    $scope.editScore = function() {
        scoreModalFactory.openModal($scope.score, {closeOnSave: true}, function saveSuccessCallbackFn(response) {
            $scope.score = response;
        });
    };

    $scope.share = function() {

    };

    $scope.deleteScore = function() {
    };
}]);