angular.module('app').directive('twitterUserScore', ['twitter', function(twitter) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            score: '='
        },
        templateUrl: 'scores/twitterUserScore.html',
        link: function($scope, element, attrs) {
            // FIXME this needs to be handled somewhere else, the right way to decide which directive
            // for a certain thing type
            if($scope.score.thing.type != 'TWITTER_UID') return;

            twitter.getTwitterUserInfo($scope.score.thing.value, function successUserInfo(data) {
                // FIXME move this logic into twitter#user_info controller
               $scope.userInfo = data.results;
            }, function errorUserInfo(response) {
                console.log(response);
            });
        }

    };
}]);