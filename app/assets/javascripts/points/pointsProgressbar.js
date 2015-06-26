angular.module('app').directive('pointsProgressbar', ['pointsToLevel', function(pointsToLevel) {
    return {
        restrict: 'E',
        replace: false,
        templateUrl: 'points/pointsProgressbar.html',
        scope: {
            points: '='
        },
        link: function($scope, $element) {
            var levelToProgressTypes = {
                NO: 'danger',
                MEH: 'info',
                YES: 'success'
            };
            $scope.progressType = levelToProgressTypes['MEH'];
            $scope.$watch('points', function(newValue) {
                var level = pointsToLevel.translate(newValue);
                $scope.progressType = levelToProgressTypes[level];
                $scope.progressValue = newValue * 10;
            });

            $element.focus();
        }
    };
}]);