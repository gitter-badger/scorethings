angular.module('app').directive('navbarTabs', ['$state', function($state) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            stateToNavbarTitles: '='
        },
        templateUrl: 'navbarTabs/navbarTabs.html',
        link: function($scope, element, attrs) {
            $scope.currentState = $state.current;
            $scope.$on('$stateChangeStart', function(event, toState) {
                $scope.currentState = toState;

            });
        }
    };
}]);