angular.module('app').directive('navbarTabs', ['$state', 'authService', function($state, authService) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            navbarStates: '='
        },
        templateUrl: 'navbarTabs/navbarTabs.html',
        link: function($scope, element, attrs) {
            $scope.currentState = $state.current;
            $scope.$on('$stateChangeStart', function(event, toState) {
                $scope.currentState = toState;
            });

            $scope.isLoggedIn = function() {
                return authService.isLoggedIn();
            };
        }
    };
}]);