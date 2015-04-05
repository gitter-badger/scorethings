angular.module('yeaskme')
    .controller('DashboardCtrl', ['$scope', function($scope) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });
    }]);
