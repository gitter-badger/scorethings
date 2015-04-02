/**
 * Created by manuisfunny on 4/2/15.
 */
angular.module('yeaskme')
    .service('AuthToken', ['localStorageService', 'jwtHelper', function(localStorageService, jwtHelper) {
        return {
            tokenName: 'authToken',
            set: function(token) {
                localStorageService.set(this.tokenName, token);
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
            }
        };
    }])
    .factory('AuthInterceptor', ['$q', '$injector', function($q, $injector) {
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
                return $q.reject(response);
            }
        };
    }])
