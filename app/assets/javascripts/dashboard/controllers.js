angular.module('app')
    .controller('MainCtrl', ['$scope', function($scope) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });
    }]);
