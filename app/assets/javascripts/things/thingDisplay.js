angular.module('app').directive('tweetDisplay', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            thing: '='
        },
        templateUrl: 'things/tweetDisplay.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
