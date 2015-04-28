angular.module('app')
    .controller('DashboardCtrl', ['$scope', 'twitterSearch', function($scope, twitterSearch) {
        $scope.$on('currentUserChanged', function(e, currentUser) {
            $scope.currentUser = currentUser;
        });

        $scope.searchForManuIsFunny = function() {
            twitterSearch.searchForManuIsFunny(
                function success(data) {
                    console.log('success searching for manuisfunny');
                    console.log(data);
                    $scope.data = data;
                },
                function error(response) {
                    console.log('error searching for manuisfunny');
                    console.log(response);
                }
            );
        };
    }]);
