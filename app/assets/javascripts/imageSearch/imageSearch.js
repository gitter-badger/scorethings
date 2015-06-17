angular.module('app').service('imageSearch', ['$http', function($http) {
    return {
        search: function(query, successCallback) {
            if(!query) {
                console.error('image search query null');
                return;
            }
            // return 3 image urls
            $http.get('/api/v1/things/search_images', {
                params: {
                    query: query,
                    size: 'small'
                },
                cache: true
            }).then(function(result) {
                var imageUrls = result.data.image_urls;
                return successCallback(imageUrls.slice(0, 3));
            });

        }
    };
}]);
