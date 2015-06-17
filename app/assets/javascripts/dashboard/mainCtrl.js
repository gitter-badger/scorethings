angular.module('app').controller('MainCtrl', ['$scope', '$rootScope', 'identity', 'authService', 'currentUser', function($scope, $rootScope, identity, authService, currentUser) {
    $scope.logout = function() {
        authService.logout();
    };

    $scope.isLoggedIn = function() {
        return authService.isLoggedIn();
    };

    $scope.$on('userLoggedIn', function() {
        currentUser.get(
            function success(currentUser) {
                identity.username = currentUser.username;
            },
            function error(response) {
            });
    });

    $rootScope.login = function(provider) {
        window.$windowScope = $scope;
        window.open('/auth/twitter', "Authenticate Account", "width=500, height=500");
    };

    $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
        $scope.$apply(function() {
            authService.storeAuthToken(token);
            $rootScope.$broadcast('userLoggedIn');
        });
    };
}]);
