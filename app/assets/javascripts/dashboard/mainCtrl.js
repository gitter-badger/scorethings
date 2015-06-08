angular.module('app').controller('MainCtrl', ['$scope', '$rootScope', 'loginModalFactory', 'identity', 'authService', 'currentUser', function($scope, $rootScope, loginModalFactory, identity, authService, currentUser) {
    $rootScope.login = function() {
        loginModalFactory.openModal();
    };

    $scope.logout = function() {
        authService.logout();
    };

    $scope.isLoggedIn = function() {
        return authService.isLoggedIn();
    };

    $scope.$on('userLoggedIn', function() {
        currentUser.get(
            function success(currentUser) {
                identity.username = currentUser.username;
            },
            function error(response) {
            });
    });
}]);
