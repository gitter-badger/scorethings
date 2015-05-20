angular.module('app').controller('NewScoreListCtrl', ['$scope', 'usSpinnerService', 'notifier', 'ScoreList', '$location', function($scope, usSpinnerService, notifier, ScoreList, $location) {
    $scope.scoreList = new ScoreList({
    });

    $scope.createScoreList = function() {
        usSpinnerService.spin('spinner-1');
        var res = $scope.scoreList.create();
        res.then(function(scoreList) {
            usSpinnerService.stop('spinner-1');
            $location.path('score_lists/' + scoreList.id);
            notifier.success('You created a score list');
        }, function(resp) {
            usSpinnerService.stop('spinner-1');
        });
    };
}]);
