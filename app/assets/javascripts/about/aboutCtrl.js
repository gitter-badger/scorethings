angular.module('app').controller('AboutCtrl', ['$scope', function($scope) {
    $scope.stateToNavbarTitle = {
        'about.scorethings': 'About scorethings',
        'about.contribute': 'Contribute',
        'about.connect': 'Connect'
    };
}]);