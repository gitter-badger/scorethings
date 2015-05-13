angular.module('app').controller('ThingSuggestionsCtrl', ['identity', '$scope', function(identity, $scope) {
    $scope.identity = identity;

    $scope.$on('userLoggedOff', function() {
        $location.path('/');
    });
}]);