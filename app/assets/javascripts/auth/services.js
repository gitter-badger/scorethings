/**
 * Created by manuisfunny on 4/2/15.
 */
angular.module('app')
    .service('AuthToken', ['localStorageService', 'jwtHelper', 'identity', function(localStorageService, jwtHelper, identity) {
        // TODO clean up this service
        return {
            tokenName: 'authToken',
            set: function(token) {
                localStorageService.set(this.tokenName, token);
                identity.twitterHandle = this.getTwitterHandle();
                identity.userId = this.getUserId();
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
            getTwitterHandle: function() {
                return this.getAttr('twitter_handle');
            },
            getUserId: function() {
                return this.getAttr('user_id');
            },
            clear: function() {
                localStorageService.remove(this.tokenName);
                identity.twitterHandle = this.getTwitterHandle();
            }
        };
    }])
    .factory('AuthInterceptor', ['$q', '$injector', 'notifier', 'authService', function($q, $injector, notifier, authService) {
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
                if(response.status == 401) {
                    notifier.error(response.statusText)
                    if(!authService.isLoggedIn()) {
                        notifier.error('You need to login to do that.');
                    } else {
                        notifier.error(response.statusText)
                    }
                    return $q.reject(response);
                } else {
                    notifier.error('Error executing last action');
                    return $q.reject(response);
                }
            }
        };
    }])
