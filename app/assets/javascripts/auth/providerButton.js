angular.module('app').directive('providerButton', function() {
    return {
        restrict: 'E',
        replace: 'true',
        templateUrl: 'auth/providerButton.html',
        scope: {
            provider: '=',
            respondToClick: '=',
            preferredProvider: '=?',
            faName: '=?'
        },
        controller: function ($scope) {
        }
    };
});