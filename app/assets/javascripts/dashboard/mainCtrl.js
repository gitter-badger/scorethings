angular.module('app').controller('MainCtrl', ['$scope', '$rootScope', 'authService', 'notifier', function($scope, $rootScope, authService, notifier) {
    $rootScope.loginWithTwitter = function() {
        var openUrl = '/auth/twitter';
        window.$windowScope = $scope;
        window.open(openUrl, "Authenticate Account", "width=500, height=500");
    };
    $scope.logout = function() {
        authService.logout();
    };
    $scope.isLoggedIn = function() {
        return authService.isLoggedIn();
    };

    $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
        $scope.$apply(function() {
            authService.storeAuthToken(token);
            notifier.success('Logged in');
        });
    };
}]);
