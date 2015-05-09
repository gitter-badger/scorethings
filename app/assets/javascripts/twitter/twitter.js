angular.module('app').factory('twitter', ['$http', function($http) {
    return {
        searchTwitterHandles: function(twitterHandle, successFn, errorFn) {
            if(!twitterHandle) {
                return errorFn('twitter username is required');
            }
           $http.get('/api/v1/twitter/handle_search', {params: {twitter_handle: twitterHandle, cache: true}})
               .success(function(data) {
                   return successFn(data);
               })
               .error(function(response) {
                   if(errorFn) {
                       return errorFn(response);
                   }
               });
       },
        getTwitterUserInfo: function(twitterUid, successFn, errorFn) {
            if(!twitterUid) {
                return errorFn('twitter uid is required');
            }
            $http.get('/api/v1/twitter/user_info', {params: {twitter_uid: twitterUid}, cache: true})
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