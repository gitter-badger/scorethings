angular.module('app').directive('twitterHashtagScore', function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            score: '='
        },
        templateUrl: 'scores/twitterHashtagScore.html',
        link: function($scope, element, attrs) {
            $scope.doSomething = function() {
                console.log('something');
            };
        }

    };
});