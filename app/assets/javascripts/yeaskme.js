angular.module('yeaskme', ['ngRoute', 'LocalStorageModule', 'angular-jwt', 'templates'])
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        localStorageServiceProvider.setPrefix('yeaskme');
        return $httpProvider.interceptors.push('AuthInterceptor');
    }]);
