angular.module('app').controller('AboutMainCtrl', ['$scope', 'NAVBAR_STATES', function($scope, NAVBAR_STATES) {
    $scope.aboutNavbarStates = NAVBAR_STATES.ABOUT;
}]);