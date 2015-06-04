angular.module('app').controller('UsersEditCtrl', ['$scope', 'User', 'identity', function($scope, User, identity) {
    if(!$scope.isLoggedIn()) {
        notifier.error('You need to be logged in to edit your profile');
        return;
    }

    var username = identity.username;

    new User({id: username}).get().then(
        function successGet(user) {
            $scope.user = user;
        },
        function errorGet() {
            notifier.error('failed to get user');
        });
}]);