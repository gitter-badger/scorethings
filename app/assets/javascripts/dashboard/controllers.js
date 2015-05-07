angular.module('app')
    .controller('MainCtrl', ['$scope', 'twitter', 'notifier', 'usSpinnerService', function($scope, twitter, notifier, usSpinnerService) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

        $scope.twitterHandle = '';

        $scope.searchTwitterHandle = function() {
            usSpinnerService.spin('spinner-1');
            twitter.searchTwitterHandle(
                $scope.twitterHandle,
                function success(response) {
                    usSpinnerService.stop('spinner-1');
                    notifier.success('succeeded in twitter accounts');
                    $scope.accounts = response.results;
                },
                function error(response) {
                    usSpinnerService.stop('spinner-1');
                    console.log('error twitter lists');
                }
            );
        };
    }]);
