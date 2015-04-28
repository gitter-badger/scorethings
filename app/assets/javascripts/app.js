angular.module('app', ['ngRoute', 'LocalStorageModule', 'angular-jwt', 'templates', 'ui.bootstrap'])
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        localStorageServiceProvider.setPrefix('scorethings');
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.username = AuthToken.getName();
    }]);