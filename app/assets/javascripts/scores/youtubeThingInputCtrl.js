angular.module('app').controller('YoutubeThingInputCtrl', ['$scope', function($scope) {
    /*
    $scope.$watch('youtubeVideoUrl', function(newValue) {
        if(newValue && youtubeVideoUrlPattern.test(newValue)) {
            $scope.youtubeVideoId = youtubeEmbedUtils.getIdFromURL($scope.youtubeVideoUrl);
        } else {
            $scope.youtubeVideoId = '';
        }
    });

    $scope.$watch('urlInput', function(newValue) {
        if(newValue && newValue.length == 11) {
            // TODO get the regex for youtube urls to ensure video id is 11 characters
            YouTubeMetadata.query(newValue,
                function success(metadata) {
                    $scope.youtubeMetadata = metadata;
                },
                function error(msg, errors) {
                    notifier.error(msg);
                    delete $scope.youtubeMetadata;
                });
            return;
        } else {
            delete $scope.youtubeMetadata;
        }
    });

    $scope.urlPattern = youtubeVideoUrlPattern;

    $scope.provideRandomYouTubeUrl = function() {
        $scope.youtubeVideoUrl = youtubeExampleVideos.getRandomYouTubeVideoUrl();
    };
    */
}]);