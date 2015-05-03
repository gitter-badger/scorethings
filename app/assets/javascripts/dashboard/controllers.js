angular.module('app')
    .controller('DashboardCtrl', ['$scope', 'twitter', 'notifier', function($scope, twitter, notifier) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

        $scope.getLists = function() {
            twitter.getLists(
                function success(lists) {
                    notifier.success('succeeded in getting lists');
                    $scope.lists = lists;
                },
                function error(response) {
                    console.log('error twitter lists');
                }
            );
        };
    }]);
