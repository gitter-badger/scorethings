angular.module('app', ['ui.router', 'templates', 'LocalStorageModule', 'angular-jwt', 'ui.bootstrap', 'rails', 'ui.slider', 'djds4rce.angular-socialshare', 'igCharLimit'])
    .config(['$httpProvider', 'localStorageServiceProvider', '$locationProvider', function($httpProvider, localStorageServiceProvider, $locationProvider) {
        $locationProvider.html5Mode(true);
        localStorageServiceProvider.setPrefix('scorethings');

        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'authService', 'AuthToken', 'currentUser', function(identity, authService, AuthToken, currentUser) {
        if(authService.isLoggedIn() && authService.isExpired()) {
            authService.logout();
            identity.username = undefined;
            identity.userId = undefined;
            return;
        }

        identity.userId = AuthToken.getUserId();
        if(identity.userId) {
            currentUser.get(
                function success(currentUser) {
                    identity.username = currentUser.username;
                },
                function error(response) {
                });
        }
    }]);