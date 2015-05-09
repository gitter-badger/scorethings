angular.module('app').controller('ShowScoreCtrl', ['$scope', '$routeParams', 'Restangular', 'twitter', function($scope, $routeParams, Restangular, twitter) {
    var scoreId = $routeParams.scoreId;
    Restangular.one('scores', scoreId).get().then(function(data) {
        $scope.score =  data.score;
        if($scope.score.thing.type != 'TWITTER_UID') return;

        twitter.getTwitterUserInfo($scope.score.thing.value, function successUserInfo(data) {
            // FIXME move this logic into twitter#user_info controller
            $scope.userInfo = data.results;
        }, function errorUserInfo(response) {
            console.log(response);
        });
    });
}]);