angular.module('app').directive('pointsProgressbar', function() {
    return {
        restrict: 'E',
        templateUrl: 'points/pointsProgressbar.html',
        scope: {
            points: '='
        },
        link: function($scope) {
            var NO_PROGRESS_TYPE = 'danger';
            var ALMOST_NO_PROGRESS_TYPE = 'warning';
            var MEH_PROGRESS_TYPE = 'info';
            var YES_PROGRESS_TYPE = 'success';
            $scope.progressType = MEH_PROGRESS_TYPE;
            $scope.$watch('points', function(newValue) {
                if(newValue < 60) {
                    $scope.progressType = NO_PROGRESS_TYPE;
                } else if(newValue < 70) {
                    $scope.progressType = ALMOST_NO_PROGRESS_TYPE;
                } else if(newValue < 80) {
                    $scope.progressType = MEH_PROGRESS_TYPE;
                } else {
                    $scope.progressType = YES_PROGRESS_TYPE;
                }
            });
        }
    };
});