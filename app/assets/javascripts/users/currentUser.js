angular.module('app').factory('currentUser', ['User', 'localStorageService', function(User, localStorageService) {
    return {
        get: function(successCallback, errorCallback) {
            User.get('current').then(
                function successGettingCurrentUser(currentUser) {
                    return successCallback(currentUser);
                }, function errorGettingCurrentUser(response) {
                    return errorCallback(response);
                });
        }

    };
}]);