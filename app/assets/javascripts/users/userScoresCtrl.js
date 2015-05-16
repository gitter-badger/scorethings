angular.module('app').controller('UserScoresCtrl', ['$scope', '$routeParams', 'User', 'notifier', function($scope, $routeParams, User, notifier) {
    var userId = $routeParams.userId;
    /*
    FIXME fix me, like now, me this shit right here homie
    User.getScores(userId).then(
        function successGetUserScores(scores) {
            $scope.scores = scores;
        },
        function errorGetUserScores(response) {
            notifier.error('failed to get user scores');
            console.log(response);
        });
    */
}]);