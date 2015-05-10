angular.module('app').controller('AccountCtrl', ['identity', '$scope', function(identity, $scope) {
    $scope.identity = identity;
    $scope.stateToNavbarTitle = {
        'account.scores': 'Scores',
        'account.scoreLists': 'Score Lists',
        'account.criteria': 'Criteria'
    };
}]);