angular.module('app').factory('loginModalFactory', ['$modal', '$rootScope', 'AUTH_PROVIDERS', function($modal, $rootScope, AUTH_PROVIDERS) {
    return {
        openModal: function() {
            $modal.open({
                templateUrl: 'auth/loginModal.html',
                size: 'sm',
                controller: ['$scope', 'AUTH_PROVIDERS', 'authService', '$modalInstance', function($scope, AUTH_PROVIDERS, authService, $modalInstance) {
                    $scope.authProviders = AUTH_PROVIDERS;

                    $scope.login = function(provider) {
                        window.$windowScope = $scope;
                        window.open('/auth/' + provider.name, "Authenticate Account", "width=500, height=500");
                    };

                    $scope.handlePopupAuthentication = function handlePopupAuthentication(token) {
                        $scope.$apply(function() {
                            authService.storeAuthToken(token);
                            $modalInstance.close();
                            $rootScope.$broadcast('userLoggedIn');
                        });
                    };
                }]
            });
        }
    };
}]);