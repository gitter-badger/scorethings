angular.module('app').controller('AccountMainCtrl', ['identity', '$scope', 'Restangular', 'SystemCriteria', 'authService', '$location', 'NAVBAR_STATES', function(identity, $scope, Restangular, SystemCriteria, authService, $location, NAVBAR_STATES) {
    $scope.currentUserInfo = {
        scores: [],
        criteria: [],
        scoreLists: []
    };

    $scope.accountNavbarStates = NAVBAR_STATES.ACCOUNT;

    SystemCriteria.getList().then(function(systemCriteria) {
        $scope.systemCriteria = systemCriteria;
    });

    $scope.identity = identity;

    $scope.$on('userLoggedOff', function() {
        $location.path('/');
    });

    $scope.getCurrentUserInfo = function() {
        Restangular.one('users', 'current_user_info').get().then(function(data) {
            $scope.currentUserInfo = data.current_user_info;
        });
    };


    if(authService.isLoggedIn()) {
        $scope.getCurrentUserInfo();
    }
}]);