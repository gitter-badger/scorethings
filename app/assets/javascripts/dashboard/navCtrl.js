angular.module('app').controller('NavCtrl', ['$scope', '$rootScope', 'identity', 'authService', function($scope, $rootScope, identity, authService) {
    $scope.identity = identity;

}]);