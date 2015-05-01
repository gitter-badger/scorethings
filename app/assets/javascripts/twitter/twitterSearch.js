angular.module('app').factory('twitterSearch', ['$http', function($http) {
    return {
       searchForManuIsFunny: function(hashTag, successFn, errorFn) {
           var url = '/tweet_things';
           $http.get(url)
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