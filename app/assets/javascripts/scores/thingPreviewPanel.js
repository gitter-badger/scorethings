angular.module('app').directive('thingPreviewPanel', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            thingPreview: '='
        },
        templateUrl: 'scores/thingPreviewPanel.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
