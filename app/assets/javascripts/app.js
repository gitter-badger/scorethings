angular.module('app', ['restangular', 'ngRoute', 'templates', 'LocalStorageModule', 'angular-jwt', 'ui.bootstrap', 'angularSpinner'])
    .config(['$httpProvider', 'localStorageServiceProvider', '$locationProvider', 'RestangularProvider', function($httpProvider, localStorageServiceProvider,  $locationProvider, RestangularProvider) {
        localStorageServiceProvider.setPrefix('scorethings');

        RestangularProvider.setBaseUrl('/api/v1');
        RestangularProvider.setRestangularFields({
            id: "_id"
        });
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.twitterHandle = AuthToken.getTwitterHandle();
    }]);