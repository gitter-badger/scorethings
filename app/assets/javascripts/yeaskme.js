angular.module('yeaskme', ['ngRoute', 'LocalStorageModule', 'angular-jwt', 'templates', 'ui.bootstrap'])
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        theMovieDb.common.api_key = '3cc5977881a9a13a3aaeb17329e63fd5';

        localStorageServiceProvider.setPrefix('yeaskme');
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.username = AuthToken.getName();
    }]);