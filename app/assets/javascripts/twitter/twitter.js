angular.module('app').factory('twitter', ['$http', function($http) {
    return {
       getLists: function(successFn, errorFn) {
           var url = '/twitter/lists.json';
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