angular.module('app').controller('UserCtrl', ['$scope', 'identity', function($scope, identity) {
    $scope.identity = identity;
}]);