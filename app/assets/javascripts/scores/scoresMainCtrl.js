angular.module('app').controller('ScoresMainCtrl', ['$scope', 'NAVBAR_STATES', function($scope, NAVBAR_STATES) {
    $scope.scoresNavbarStates = NAVBAR_STATES.SCORES;
}]);

