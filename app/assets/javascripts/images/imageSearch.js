angular.module('app').service('imageSearch', ['$http', function($http) {
    return {
        search: function(query, successCallback) {
            if(!query) {
                console.error('image search query null');
                return;
            }
            $http.get('/api/v1/images/search', {
                params: { query: query },
                cache: true
            }).then(function(result) {
                var imageUrls = result.data.image_urls;
                return successCallback(imageUrls);
            });

        }
    };
}]);