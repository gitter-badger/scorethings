angular.module('app').controller('MainCtrl', ['scoreCategoriesData', '$scope', '$rootScope', 'loginModalFactory', 'authService', function(scoreCategoriesData, $scope, $rootScope, loginModalFactory, authService) {
    $rootScope.login = function() {
        loginModalFactory.openModal();
    };

    $scope.logout = function() {
        authService.logout();
    };

    $scope.isLoggedIn = function() {
        return authService.isLoggedIn();
    };

    $scope.init = function(scoreCategories) {
        $scope.$evalAsync(scoreCategoriesData.set(scoreCategories));
    };
}]);
