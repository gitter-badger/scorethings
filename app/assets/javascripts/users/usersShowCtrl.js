angular.module('app').controller('UsersShowCtrl', ['$scope', '$stateParams', 'User', 'notifier', 'identity', function($scope, $stateParams, User, notifier, identity) {
    var username = $stateParams.username;
    $scope.identity = identity;

    User.query({username: username}).then(
        function successGet(user) {
            $scope.user = user;
        },
        function errorGet(response) {
            notifier.error('failed to get user');
            console.log(response);
        });
}]);