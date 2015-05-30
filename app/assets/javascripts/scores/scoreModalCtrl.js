angular.module('app').controller('ScoreModalCtrl', ['scoreInput', '$scope', '$modalInstance', 'ScoreThingService', 'scoreCategoriesData', 'notifier', function(scoreInput, $scope, $modalInstance, ScoreThingService, scoreCategoriesData, notifier) {
    $scope.score = angular.extend({}, scoreInput);
    $scope.scoreCategories = scoreCategoriesData.get();
    console.log(scoreInput.thing);

    if(!$scope.score.scoreCategoryId) {
        // initialize new score to have score category general selected
        // TODO this may need to be done outside of modal, in method call to
        // open modal
        var generalScoreCategory = scoreCategoriesData.getGeneralScoreCategory();
        $scope.score.scoreCategory = generalScoreCategory;
        $scope.score.scoreCategoryId = generalScoreCategory.id;
    }

    $scope.cancel = function() {
        $modalInstance.dismiss();
    };

    $scope.save = function() {
        ScoreThingService.createOrUpdateScore($scope.score,
            function successCreateOrSaveScore(score) {
                $modalInstance.close(score);
            },
            function errorCreateOrSaveScore(errorMsg) {
                notifier.error('failed to save score: ' + errorMsg);
            });
    };
}]);