angular.module('app').controller('UserScoresCtrl', ['$scope', '$routeParams', 'User', 'notifier', function($scope, $routeParams, User, notifier) {
    var userId = $routeParams.userId;
    User.get(userId).then(
        function successGetUserScores(scores) {
            console.log(scores);
            $scope.scores = scores;
        },
        function errorGetUserScores(response) {
            console.log(response);
            notifier.error('failed to get user scores');
        });
}]);