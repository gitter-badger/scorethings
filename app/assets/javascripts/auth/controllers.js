/**
 *
 * Created by manuisfunny on 4/2/15.
 */

angular.module('app')
    .controller('AuthCtrl', ['$scope', '$rootScope', '$window', '$interval', '$http', 'AuthToken', 'identity', 'notifier',
        function($scope, $rootScope, $window, $interval, $http, AuthToken, identity, notifier) {
        $scope.identity = identity;

        $scope.applyToken = function(token) {
            AuthToken.set(token);
        };

        $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
            $scope.$apply(function() {
                $scope.applyToken(token);
                notifier.success('Logged in');
            });
        };

        $scope.isLoggedIn = function() {
            return !!AuthToken.isSet();
        };

        $scope.logout = function() {
            AuthToken.clear();
            notifier.success('Logged out');
        };

        $scope.login = function() {
            var openUrl = '/auth/twitter';
            window.$windowScope = $scope;
            window.open(openUrl, "Authenticate Account", "width=500, height=500");
        };
    }]);