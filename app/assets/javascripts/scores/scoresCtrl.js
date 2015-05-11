angular.module('app').controller('ScoresCtrl', ['$scope', function($scope) {
    $scope.stateToNavbarTitle = {
        'scores.search': 'Search Scores',
        'scores.new': 'Create New Score'
    };
}]);

