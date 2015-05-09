angular.module('app')
    .controller('MainCtrl', ['$scope', 'twitter', 'notifier', 'usSpinnerService', function($scope, twitter, notifier, usSpinnerService) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

    }]);
