angular.module('app').controller('AccountCtrl', ['identity', '$scope', 'Restangular', function(identity, $scope, Restangular) {
    $scope.currentUserInfo = {
        scores: [],
        criteria: [],
        scoreLists: []
    };

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