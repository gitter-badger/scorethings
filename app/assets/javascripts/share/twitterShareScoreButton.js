angular.module('app').directive('twitterShareScoreButton', ['$location', function($location) {
    return {
        restrict: 'E',
        replace: 'false',
        templateUrl: "share/twitterShareScoreButton.html",
        scope: {
            thingTitle: '=thingTitle',
            thingType: '=thingType',
            points: '=points',
            good: '=good'
        },
        controller: ['$scope', function($scope) {
            $scope.url = $location.absUrl();
        }]
    };
}]);