angular.module('app').controller('UsersEditCtrl', ['$scope', 'User', 'identity', 'notifier', '$state', '$modal', function($scope, User, identity, notifier, $state, $modal) {
    if(!$scope.isLoggedIn()) {
        notifier.error('You need to be logged in to edit your profile');
        return;
    }


    console.log(identity);
    User.query({id: identity.userId}).then(
        function successGet(user) {
            $scope.user = user;
        },
        function errorGet() {
            notifier.error('failed to get user');
        });

    $scope.save = function() {
        new User({username: $scope.user.username}).update().then(
            function saveSuccess(user) {
                $scope.user = user;
                identity.username = user.username;
                notifier.success('updated your user info');
                $state.go('users.show', {username: user.username});
            },
            function saveError(response) {
                notifier.error('failed to update your user info');
            });
    };

    $scope.deleteUser = function() {
        var modalInstance = $modal.open({
            templateUrl: 'users/deleteUserModal.html',
            size: 'md',
            controller: ['$scope', '$modalInstance', function($scope, $modalInstance) {
                $scope.confirmDelete = function() {
                    $modalInstance.close();
                };

                $scope.cancel = function() {
                    $modalInstance.dismiss();
                };
            }]
        });

        modalInstance.result.then(
            function confirmDelete() {
                new User().delete().then(function() {
                    $scope.logout();
                    $state.go('home');
                    notifier.success('You deleted your user account');
                }, function error() {
                    notifier.error('There was a problem deleting your user account');
                });
            });
    };
}]);
