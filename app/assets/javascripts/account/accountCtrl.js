angular.module('app').controller('AccountCtrl', ['identity', '$scope', 'Restangular', 'SystemCriteria', function(identity, $scope, Restangular, SystemCriteria) {
    $scope.currentUserInfo = {
        scores: [],
        criteria: [],
        scoreLists: []
    };

    SystemCriteria.getList().then(function(systemCriteria) {
        $scope.systemCriteria = systemCriteria;
    });

    $scope.identity = identity;
    $scope.stateToNavbarTitle = {
        'account.scoreLists': 'Score Lists',
        'account.criteria': 'Criteria',
        'account.scores': 'Scores'
    };


    Restangular.one('users', 'current_user_info').get().then(function(data) {
        $scope.currentUserInfo = data.current_user_info;
    });
}]);