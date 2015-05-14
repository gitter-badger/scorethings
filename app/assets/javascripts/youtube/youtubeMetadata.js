angular.module('app').factory('YoutubeMetadata', ['$http', function($http) {
    function mapMetadataResults(response) {
        return {
            title: response.data.title,
            videoId: response.data.id,
            thumbnail: response.data.thumbnail,
            player: response.data.player
        };
    }

    function mapMetadataErrorResults(response) {
        return {
            message: response.error.message,
            errors: response.error.errors.map(function(error) {
                return error.internalReason;
            })
        };
    }


    return {
        query: function(videoId, successFn, errorFn) {
            var youTubeApiQueryUrl = 'http://gdata.youtube.com/feeds/api/videos/' + videoId + '?v=2&alt=jsonc';
            $http.get(youTubeApiQueryUrl, {})
                .success(
                function handleSuccessResponse(response) {
                    return successFn(mapMetadataResults(response));
                })
                .error(function handleErrorResponse(response) {
                    var errorMsg = 'Failed to retrieve YouTube video metadata using url: ' + youTubeApiQueryUrl;
                    return errorFn(errorMsg, mapMetadataErrorResults(response));
                })
        }
    };
}]);