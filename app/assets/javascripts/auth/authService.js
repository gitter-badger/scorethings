angular.module('app').service('authService', ['AuthToken', '$rootScope', function(AuthToken, $rootScope) {
    return {
        isLoggedIn: function() {
            return !!AuthToken.isSet();
        },
        storeAuthToken: function(token) {
            AuthToken.set(token);
            $rootScope.$broadcast('userLogsIn');
        },
        isExpired: function() {
            return AuthToken.isExpired();
        },
        logout: function() {
            AuthToken.clear();
            $rootScope.$broadcast('userLogsOff');
        }
    };
}]);