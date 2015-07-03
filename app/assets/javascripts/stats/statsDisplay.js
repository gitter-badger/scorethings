angular.module('app').directive('statsDisplay', function() {
    return {
        restrict: 'E',
        replace: false,
        templateUrl: 'stats/statsDisplay.html',
        scope: {
            stats: '=',
            totalsUrl: '=?'
        }
    };
});
