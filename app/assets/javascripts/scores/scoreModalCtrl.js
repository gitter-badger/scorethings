angular.module('app').controller('ScoreModalCtrl', ['scoreInput', '$scope', '$modalInstance', 'ScoreThingService', 'notifier', function(scoreInput, $scope, $modalInstance, ScoreThingService, notifier) {
    $scope.score = angular.extend({}, scoreInput);

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