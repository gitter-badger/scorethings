angular.module('app').directive('twitterShareScoreButton', ['$location', 'pointsToLevel', function($location, pointsToLevel) {
    return {
        restrict: 'E',
        replace: 'false',
        templateUrl: "share/twitterShareScoreButton.html",
        scope: {
            score: '='
        },
        controller: ['$scope', function($scope) {
            $scope.$watch('score', function(score) {
                if(!score) return;

                console.log(score);
                var pointsLevel = pointsToLevel.translate(score.points);

                $scope.url = $location.absUrl();
                $scope.text = "Score for " + score.thing.title + ".  ";
                if($scope.score.criterion) {
                    $scope.text += score.criterion.name + "?  ";
                }
                $scope.text += pointsLevel + " (" + score.points + "/10)";
            });
        }]
    };
}]);