angular.module('yeaskme', ['ngRoute', 'LocalStorageModule', 'angular-jwt', 'templates'])
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        localStorageServiceProvider.setPrefix('yeaskme');
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.username = AuthToken.getName();
    }]);