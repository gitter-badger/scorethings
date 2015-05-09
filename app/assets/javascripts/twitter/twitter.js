angular.module('app').factory('twitter', ['$http', function($http) {
    return {
        searchTwitterHandles: function(twitterHandle, successFn, errorFn) {
            if(!twitterHandle) {
                return errorFn('twitter username is required');
            }
           $http.get('/api/v1/things/search', {params: {twitter_handle: twitterHandle}})
               .success(function(data) {
                   return successFn(data);
               })
               .error(function(response) {
                   if(errorFn) {
                       return errorFn(response);
                   }
               });
       }
    };

}]);