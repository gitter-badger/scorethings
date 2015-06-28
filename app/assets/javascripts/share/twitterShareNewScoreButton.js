angular.module('app').directive('twitterShareNewScoreButton', ['$location', 'shareText', function($location, shareText) {
    return {
        restrict: 'E',
        replace: 'true',
        templateUrl: "share/twitterShareScoreButton.html",
        scope: {
            criterion: '=',
            thing: '='
        },
        controller: ['$scope', function($scope) {
            $scope.url = $location.absUrl();

            $scope.$on('$locationChangeSuccess', function() {
                $scope.url = $location.absUrl();
            });

            var criterionName = null;
            var thingTitle = null;

            $scope.$watch('criterion', function(criterion) {
                if(!criterion) return;

                criterionName = criterion && criterion.name;
                updateTextAndTitle(thingTitle, criterionName);
            });

            $scope.$watch('thing', function(thing) {
                if(!thing) return;

                thingTitle = thing.title;
                updateTextAndTitle(thingTitle, criterionName);
            });

            function updateTextAndTitle(thingTitle, criterionName) {
                $scope.text = shareText.generateNewScoreText(thingTitle, criterionName);
                $scope.title = shareText.generateNewScoreTitle(thingTitle, criterionName);
            }
        }]
    };
}]);