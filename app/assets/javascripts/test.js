/**
 *
 * Created by manuisfunny on 3/28/15.
 */


angular.module('yeaskme', ['LocalStorageModule', 'angular-jwt'])
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
                var payload = jwtHelper.decodeToken(token);

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
    .config(['$httpProvider', 'localStorageServiceProvider', function($httpProvider, localStorageServiceProvider) {
        localStorageServiceProvider.setPrefix('yeaskme');
        return $httpProvider.interceptors.push('AuthInterceptor');
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
    .controller('HomeCtrl', ['$scope', '$rootScope', '$window', '$interval', '$http', 'AuthToken', function($scope, $rootScope, $window, $interval, $http, AuthToken) {
        $scope.message = '';

        $scope.currentUser = AuthToken.getName();

        $scope.applyToken = function(token) {
            AuthToken.set(token);
            $scope.currentUser = AuthToken.getName();
        };

        $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
            $scope.$apply(function() {
                $scope.applyToken(token);
            })
        };

        $scope.isLoggedIn = function() {
            return !!AuthToken.isSet();
        };

        $scope.logout = function() {
            AuthToken.clear();
            delete $scope.currentUser;
        };

        $scope.login = function(oauthProvider) {
            var openUrl = '/auth/' + oauthProvider;
            window.$windowScope = $scope;
            window.open(openUrl, "Authenticate Account", "width=500, height=500");
        };
    }]);
