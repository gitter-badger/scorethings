angular.module('app', ['ui.router', 'templates', 'LocalStorageModule', 'angular-jwt', 'ui.bootstrap', 'angularSpinner', 'siyfion.sfTypeahead', 'ui.bootstrap-slider', 'rails'])
    .config(['$httpProvider', 'railsSerializerProvider', 'localStorageServiceProvider', '$locationProvider', function($httpProvider, railsSerializerProvider, localStorageServiceProvider,  $locationProvider) {
        localStorageServiceProvider.setPrefix('scorethings');

        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.username = AuthToken.getUsername();
        identity.userId = AuthToken.getUserId();
    }]);