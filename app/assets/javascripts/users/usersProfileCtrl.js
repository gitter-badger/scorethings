angular.module('app').controller('UsersProfileCtrl', ['$scope', '$stateParams', 'Profile', 'notifier', function($scope, $stateParams, Profile, notifier) {
    var username = $stateParams.username;

    new Profile({id: username}).get().then(
        function successGet(profile) {
            $scope.profile = profile;
            console.log(user.user)
        },
        function errorGet(response) {
            notifier.error('failed to get profile');
            console.log(response);
        });
}]);