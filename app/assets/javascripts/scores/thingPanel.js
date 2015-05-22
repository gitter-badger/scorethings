angular.module('app').directive('thingPanel', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            thing: '='
        },
        templateUrl: 'scores/thingPanel.html',
        link: function($scope, element, attrs) {
            $scope.scoreThing = function() {
                console.log('scoring thing');
                console.log($scope.thing);
            };
        }
    };
}]);
