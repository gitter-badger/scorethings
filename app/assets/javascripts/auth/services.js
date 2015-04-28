/**
 * Created by manuisfunny on 4/2/15.
 */
angular.module('app')
    .service('AuthToken', ['localStorageService', 'jwtHelper', 'identity', function(localStorageService, jwtHelper, identity) {
        return {
            tokenName: 'authToken',
            set: function(token) {
                localStorageService.set(this.tokenName, token);
                identity.username = this.getName();
            },
            isSet: function() {
                return !!this.get();
            },
            get: function() {
                return localStorageService.get(this.tokenName);
            },
            getAttr: function(attr) {
                var token = this.get();
                var payload = token && jwtHelper.decodeToken(token);
                return payload && payload[attr];
            },
            getName: function() {
                return this.getAttr('name');
            },
            clear: function() {
                localStorageService.remove(this.tokenName);
                identity.username = this.getName();
            }
        };
    }])
    .factory('AuthInterceptor', ['$q', '$injector', 'notifier', function($q, $injector, notifier) {
        return {
            request: function(config) {
                // called on every outgoing HTTP request
                var AuthToken = $injector.get("AuthToken");
                var token = AuthToken.get();
                config.headers = config.headers || {};
                if(token) {
                    config.headers.Authorization = "Bearer " + token;
                }
                return config || $q.when(config);
            },
            responseError: function(response) {
                // TODO handle error response
                notifier.error('Error executing last action');
                return $q.reject(response);
            }
        };
    }])
