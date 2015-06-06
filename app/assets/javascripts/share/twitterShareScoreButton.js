angular.module('app').directive('twitterShareScoreButton', function($location) {
    return {
        restrict: 'E',
        replace: 'true',
        templateUrl: "share/twitterShareScoreButton.html",
        scope: {
            thingTitle: '=thingTitle',
            thingType: '=thingType',
            points: '=points',
            good: '=good'
        },
        controller: function($scope) {
            $scope.url = $location.absUrl();
        }
    };
});