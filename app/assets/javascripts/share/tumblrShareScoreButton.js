angular.module('app').directive('tumblrShareScoreButton', ['$location', function($location) {
    return {
        restrict: 'E',
        replace: 'false',
        templateUrl: "share/tumblrShareScoreButton.html",
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