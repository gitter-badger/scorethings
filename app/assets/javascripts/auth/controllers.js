/**
 *
 * Created by manuisfunny on 4/2/15.
 */

angular.module('yeaskme')
    .controller('AuthCtrl', ['$scope', '$rootScope', '$window', '$interval', '$http', 'AuthToken', 'identity', function($scope, $rootScope, $window, $interval, $http, AuthToken, identity) {
        $scope.message = '';

        $scope.identity = identity;

        $scope.applyToken = function(token) {
            AuthToken.set(token);
        };

        $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
            $scope.$apply(function() {
                $scope.applyToken(token);
            });
        };

        $scope.isLoggedIn = function() {
            return !!AuthToken.isSet();
        };

        $scope.logout = function() {
            AuthToken.clear();
        };

        $scope.login = function(oauthProvider) {
            var openUrl = '/auth/' + oauthProvider;
            window.$windowScope = $scope;
            window.open(openUrl, "Authenticate Account", "width=500, height=500");
        };
    }]);