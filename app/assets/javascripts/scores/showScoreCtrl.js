angular.module('app').controller('ShowScoreCtrl', ['$scope', '$stateParams', 'Restangular', 'twitter', function($scope, $stateParams, Restangular, twitter) {
    var scoreId = $stateParams.scoreId;
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