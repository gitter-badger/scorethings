angular.module('app').factory('twitterSearch', ['$http', function($http) {
    return {
       searchForManuIsFunny: function(successFn, errorFn) {
           $http.get('/tweet_things?query=manuisfunny')
               .success(function(data) {
                   return successFn(data);
               })
               .error(function(response) {
                   return errorFn(response);
               });
       }
    };

}]);