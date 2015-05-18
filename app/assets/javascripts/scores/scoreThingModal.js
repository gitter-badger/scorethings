angular.module('app').controller('ScoreThingModalCtrl', ['$scope', '$modalInstance', '$http', 'thingPreview', 'scoreCategories', 'notifier', 'usSpinnerService', function($scope, $modalInstance, $http, thingPreview, scoreCategories, notifier, usSpinnerService) {
    function initializeScore() {
        $scope.score = {
            // TODO turn thingPreview into thing (fewer attributes)?
            thing: thingPreview,
            points: 75,
            score_category_id: null
        };
    }

    $scope.thingPreview = thingPreview;

    initializeScore();
    $scope.showRecenlySavedScoreMessage = false;

    scoreCategories.getAll().then(
        function success(scoreCategories) {
            $scope.scoreCategories = scoreCategories;
        },
        function error(errorMsg) {
            notifier.error(errorMsg);
        }
    );

    $scope.createAnotherScore = function() {
        initializeScore();
        $scope.showRecenlySavedScoreMessage = false;
    };

    $scope.clear = initializeScore;

    $scope.createScore = function() {
        usSpinnerService.spin('spinner-1');
        $http.post('/api/v1/scores', {score: $scope.score})
            .success(function(response) {
                usSpinnerService.stop('spinner-1');
                $scope.score = response.score;
                notifier.success('You just scored ' + $scope.score.thing.display_value);
                $scope.showRecenlySavedScoreMessage = true;
            }).error(function(response) {
                usSpinnerService.stop('spinner-1');
                notifier.error('There was a problem scoring that thing');
            });
    };

    $scope.close = function() {
        $modalInstance.close();
    };


    $scope.cancel = function() {
        $modalInstance.dismiss();
    };
}]);
