angular.module('app').directive('youTubeMetadataDisplay', function() {
    return {
        templateUrl: 'youtube/youtubeMetadataDisplay.html',
        restrict: 'E',
        scope: {
            metadata: '='
        },
        controller: function($scope) {
        }
    };
});