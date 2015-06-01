angular.module('app').controller('UsersShowCtrl', ['$scope', '$stateParams', 'User', 'notifier', function($scope, $stateParams, User, notifier) {
    var username = $stateParams.username;

    new User({id: username}).get().then(
        function successGet(user) {
            $scope.user = user;
            console.log(user.user)
        },
        function errorGet(response) {
            notifier.error('failed to get user');
            console.log(response);
        });
}]);