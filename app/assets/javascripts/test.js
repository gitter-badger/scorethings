/**
 *
 * Created by manuisfunny on 3/28/15.
 */


angular.module('yeaskme', ['LocalStorageModule', 'angular-jwt'])
    .service('AuthToken', ['localStorageService', 'jwtHelper', function(localStorageService, jwtHelper) {
        return {
            set: function(token) {
                localStorageService.set('token', token);
            },
            get: function() {
                return localStorageService.get('token');
            },
            getName: function() {
                var token = localStorageService.get('token');
                if(!token) return;

                return jwtHelper.decodeToken(token) && jwtHelper.decodeToken(token).name;
            },
            clear: function() {
                localStorageService.remove('token');
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
    .controller('myCtrl', ['$scope', '$rootScope', '$window', '$interval', '$http', 'AuthToken', function($scope, $rootScope, $window, $interval, $http, AuthToken) {
        $scope.message = '';

        $scope.currentUser = AuthToken.getName();

        $scope.applyToken = function(token) {
            console.log('token received');
            console.log(token);
            AuthToken.set(token);
            $scope.currentUser = AuthToken.getName();
        };

        $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
            $scope.$apply(function() {
                $scope.applyToken(token);
            })
        };

        $scope.loggedIn = function() {
            return !!AuthToken.get();
        };

        $scope.logout = function() {
            AuthToken.clear();
            delete $scope.currentUser;
            delete $scope.securedThing;
            $scope.message = 'logged out';
        };

        $scope.getSecuredThing = function() {
            delete $scope.securedThing;

            $http.get('/secured_thing')
                .success(function(data) {
                    $scope.securedThing = data;
                    $scope.message = 'succeeded in getting secured thing';
                })
                .error(function(resp, error) {
                    $scope.message = 'failed to get secured thing';
                });
        };

        $scope.login = function(oauthProvider) {
            var openUrl = '/auth/' + oauthProvider;
            window.$windowScope = $scope;
            window.open(openUrl, "Authenticate Account", "width=500, height=500");
        };
    }]);
