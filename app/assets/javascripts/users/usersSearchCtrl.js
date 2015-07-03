angular.module('app').controller('UsersSearchCtrl', ['$scope', 'User', '$location', 'notifier', function($scope, User, $location, notifier) {
    $scope.notFound = false;

    $scope.search = function() {
        $scope.notFound = false;

        $location.search({
            query: $scope.query,
        });

        User.get('search', {query: $scope.query}).then(function(users) {
            $scope.users = users;
            $scope.notFound = !$scope.users.length;
        }, function() {
            $scope.notFound = false;
            notifier.error('failed to search for users');
            return;
        });
    };

    $scope.query = $location.$$search.query;
    if($scope.query) {
        $scope.search();
    }

}]);