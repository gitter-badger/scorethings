angular.module('app').directive('twitterShareScoreButton', ['$location', 'shareText', function($location, shareText) {
    return {
        restrict: 'E',
        replace: 'true',
        templateUrl: "share/twitterShareScoreButton.html",
        scope: {
            score: '='
        },
        controller: ['$scope', function($scope) {
            $scope.url = $location.absUrl();
            $scope.$on('$locationChangeSuccess', function() {
                $scope.url = $location.absUrl();
            });

            $scope.$watch('score', function(score) {
                if(!score) return;

                var thingTitle = score.thing.title;
                var points = score.points;
                var criterionName = score.criterion && score.criterion.name;
                $scope.text = shareText.generateScoreText(points, thingTitle, criterionName);
            });
        }]
    };
}]);