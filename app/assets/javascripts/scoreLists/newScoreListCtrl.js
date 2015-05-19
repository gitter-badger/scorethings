angular.module('app').controller('NewScoreListCtrl', ['$scope', 'usSpinnerService', 'notifier', '$http', '$location', function($scope, usSpinnerService, notifier, $http, $location) {
    $scope.scoreList = {
        scoreListThings: []
    };

    $scope.createScoreList = function() {
        usSpinnerService.spin('spinner-1');
        $http.post('/api/v1/score_lists', {score_list: $scope.scoreList})
            .success(function(response) {
                usSpinnerService.stop('spinner-1');
                $location.path('score_lists/' + response.score_list.id);
                notifier.success('You created a score list');
            }).error(function(response) {
                usSpinnerService.stop('spinner-1');
            });
    };
}]);
