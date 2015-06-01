angular.module('app').controller('UpdateScoreModalCtrl', ['scoreInput', '$scope', '$modalInstance', 'Score', 'scoreCategoriesData', 'notifier', function(scoreInput, $scope, $modalInstance, Score, scoreCategoriesData, notifier) {
    $scope.webThing = scoreInput.webThing;
    $scope.score = angular.extend({}, scoreInput);
    $scope.scoreCategories = scoreCategoriesData.get();

    var generalScoreCategory = scoreCategoriesData.getGeneralScoreCategory();
    $scope.score.scoreCategory = generalScoreCategory;
    $scope.score.scoreCategoryId = generalScoreCategory.id;

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        new Score($scope.score).update().then(
            function successUpdate(score) {
                $modalInstance.close(score);
            },
            function errorUpdate(errorMsg) {
                notifier.error('failed to save score: ' + errorMsg);
            });
    };
}]);
