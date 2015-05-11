angular.module('app', ['restangular', 'ui.router', 'templates', 'LocalStorageModule', 'angular-jwt', 'ui.bootstrap', 'angularSpinner'])
    .config(['$httpProvider', 'localStorageServiceProvider', '$locationProvider', 'RestangularProvider', function($httpProvider, localStorageServiceProvider,  $locationProvider, RestangularProvider) {
        localStorageServiceProvider.setPrefix('scorethings');

        RestangularProvider.setBaseUrl('/api/v1');
        RestangularProvider.setRestangularFields({
            id: "_id"
        });
        return $httpProvider.interceptors.push('AuthInterceptor');
    }])
    .factory('SystemCriteria', ['Restangular', function(Restangular) {
        return Restangular.service('criteria/system');
    }])
    .run(['identity', 'AuthToken', function(identity, AuthToken) {
        identity.twitterHandle = AuthToken.getTwitterHandle();
    }]);