angular.module('app', ['ui.router', 'templates', 'LocalStorageModule', 'angular-jwt', 'ui.bootstrap', 'rails', 'ui.slider'])
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        localStorageServiceProvider.setPrefix('scorethings');

        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'authService', 'AuthToken', function(identity, authService, AuthToken) {
        if(authService.isLoggedIn() && authService.isExpired()) {
            authService.logout();
            identity.username = undefined;
            identity.userId = undefined;
            identity.settings = undefined;
            return;
        }
        identity.username = AuthToken.getUsername();
        identity.userId = AuthToken.getUserId();
        identity.settings = AuthToken.getSettings();
    }]);