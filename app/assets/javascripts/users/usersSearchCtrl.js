angular.module('app').controller('UsersSearchCtrl', ['$scope', 'User', function($scope, User) {
    $scope.searchForScores = function() {
        User.query('/search', {query: $scope.query}).then(function(users) {
            $scope.users = users;
        }, function() {
            notifier.error('failed to search for users');
            return;
        });
    };
}]);