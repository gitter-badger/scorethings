angular.module('app', ['ngRoute', 'LocalStorageModule', 'angular-jwt', 'templates', 'ui.bootstrap', 'angularSpinner'])
    .config(['$httpProvider', 'localStorageServiceProvider', '$locationProvider', function($httpProvider, localStorageServiceProvider,  $locationProvider) {
        $locationProvider.html5Mode(true);
        localStorageServiceProvider.setPrefix('scorethings');
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.twitterHandle = AuthToken.getTwitterHandle();
    }]);