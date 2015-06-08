angular.module('app').controller('UsersSearchCtrl', ['$scope', 'User', '$location', 'notifier', function($scope, User, $location, notifier) {
    $scope.search = function() {
        $location.search({
            query: $scope.query,
        });

        User.get('search', {query: $scope.query}).then(function(users) {
            $scope.users = users;
        }, function() {
            notifier.error('failed to search for users');
            return;
        });
    };

    $scope.query = $location.$$search.query;
    if($scope.query) {
        $scope.search();
    }

}]);