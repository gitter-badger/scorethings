angular.module('app').factory('twitter', ['$http', function($http) {
    return {
        searchTwitterHandle: function(twitterHandle, successFn, errorFn) {
            if(!twitterHandle) {
                console.log('twitterHandle required');
                return;
            }
           $http.get('/api/v1/things/search',
               {
                   params: {
                       twitter_handle: twitterHandle
                   }
               })
               .success(function(data) {
                   console.log(data);
                   return successFn(data);
               })
               .error(function(response) {
                   console.log(response);
                   if(errorFn) {
                       return errorFn(response);
                   }
               });
       }
    };

}]);