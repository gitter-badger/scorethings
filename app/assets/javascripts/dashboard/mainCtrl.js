angular.module('app').controller('MainCtrl', ['scoreCategoriesData', '$scope', '$rootScope', 'loginModalFactory', 'authService', 'newScoreListModalFactory', '$state', function(scoreCategoriesData, $scope, $rootScope, loginModalFactory, authService, newScoreListModalFactory, $state) {
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

    $scope.showNewScoreListModal = function() {
        newScoreListModalFactory.openModal(function scoreListCreatedCallback(scoreList) {
            console.log(scoreList);
            $state.go('scoreLists.detail', {scoreListId: scoreList.token});
        });
    };
}]);
