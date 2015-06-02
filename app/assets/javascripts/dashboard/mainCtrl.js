angular.module('app').controller('MainCtrl', ['$scope', '$rootScope', 'loginModalFactory', 'authService', function($scope, $rootScope, loginModalFactory, authService) {
    $rootScope.login = function() {
        loginModalFactory.openModal();
    };

    $scope.logout = function() {
        authService.logout();
    };

    $scope.isLoggedIn = function() {
        return authService.isLoggedIn();
    };
}]);
