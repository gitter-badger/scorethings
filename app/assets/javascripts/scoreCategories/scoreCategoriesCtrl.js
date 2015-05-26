angular.module('app').controller('ScoreCategoriesCtrl', ['$scope', 'scoreCategoriesData', 'notifier', function($scope, scoreCategoriesData, notifier) {
    $scope.scoreCategories = [];
    angular.forEach(scoreCategoriesData.map(), function(val, key) {
        $scope.scoreCategories.push(val);
    });
}]);