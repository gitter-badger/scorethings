angular.module('app').controller('ScoreCategoriesCtrl', ['$scope', 'scoreCategoriesData', 'notifier', function($scope, scoreCategoriesData, notifier) {
    $scope.scoreCategories = [];
    console.log(scoreCategoriesData.get());
    angular.forEach(scoreCategoriesData.get(), function(val) {
        $scope.scoreCategories.push(val);
    });
}]);