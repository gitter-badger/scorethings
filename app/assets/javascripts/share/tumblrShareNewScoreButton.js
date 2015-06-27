angular.module('app').directive('tumblrShareNewScoreButton', ['$location', 'shareText', function($location, shareText) {
    return {
        restrict: 'E',
        replace: 'false',
        templateUrl: "share/tumblrShareScoreButton.html",
        scope: {
            criterion: '=',
            wikidataItem: '='
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

            $scope.$watch('wikidataItem', function(wikidataItem) {
                if(!wikidataItem) return;

                thingTitle = wikidataItem.title;
                updateTextAndTitle(thingTitle, criterionName);
            });

            function updateTextAndTitle(thingTitle, criterionName) {
                $scope.text = shareText.generateNewScoreText(thingTitle, criterionName);
                $scope.title = shareText.generateNewScoreTitle(thingTitle, criterionName);
            }
        }]
    };
}]);