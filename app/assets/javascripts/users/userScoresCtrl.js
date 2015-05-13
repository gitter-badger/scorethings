angular.module('app').controller('UserScoresCtrl', ['$scope', '$routeParams', 'User', 'notifier', function($scope, $routeParams, User, notifier) {
    var userId = $routeParams.userId;
    User.getScores(userId).then(
        function successGetUserScores(scores) {
            $scope.scores = scores;
        },
        function errorGetUserScores(response) {
            notifier.error('failed to get user scores');
            console.log(response);
        });
}]);