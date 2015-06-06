angular.module('app').directive('tumblrShareScoreButton', ['$location', function($location) {
    return {
        restrict: 'E',
        replace: 'true',
        templateUrl: "share/tumblrShareScoreButton.html",
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
}]);