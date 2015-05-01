angular.module('app')
    .controller('DashboardCtrl', ['$scope', 'twitterSearch', 'notifier', function($scope, twitterSearch, notifier) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

        $scope.searchForManuIsFunny = function() {
            twitterSearch.searchForManuIsFunny(
                'manuisfunny',
                function success(things) {
                    notifier.success('succeeded in getting things');
                    $scope.things = things;
                },
                function error(response, other) {
                    console.log('error searching for manuisfunny');
                }
            );
        };
    }]);
