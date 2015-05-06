angular.module('app')
    .controller('DashboardCtrl', ['$scope', 'twitter', 'notifier', function($scope, twitter, notifier) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

        $scope.twitterHandle = '';

        $scope.searchTwitterHandle = function() {
            twitter.searchTwitterHandle(
                $scope.twitterHandle,
                function success(response) {
                    notifier.success('succeeded in twitter accounts');
                    $scope.accounts = response.results;
                },
                function error(response) {
                    console.log('error twitter lists');
                }
            );
        };
    }]);
