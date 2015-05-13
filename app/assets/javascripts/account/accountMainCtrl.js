angular.module('app').controller('AccountMainCtrl', ['identity', '$scope', function(identity, $scope) {
    $scope.identity = identity;

    $scope.$on('userLoggedOff', function() {
        $location.path('/');
    });
}]);