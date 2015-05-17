angular.module('app').controller('ScoreThingModalCtrl', ['$scope', '$modalInstance', '$http', 'thing', 'scoreCategories', 'notifier', function($scope, $modalInstance, $http, thing, scoreCategories, notifier) {
    $scope.thing = thing;
    scoreCategories.getAll().then(
        function success(scoreCategories) {
            $scope.scoreCategories = scoreCategories;
        },
        function error(errorMsg) {
            notifier.error(errorMsg);
        }
    );

    $scope.score = {
        thing: $scope.thing,
        points: 0,
        score_category_id: null
    };

    $scope.createScore = function() {
        $http.post('/api/v1/scores', {score: $scope.score})
            .success(function(response) {
                console.log(response);
                $modalInstance.close(response.score);
            }).error(function(response) {
                $modalInstance.dismiss({error: response.error});
            });
    };

    $scope.cancel = function() {
        $modalInstance.dismiss('now dismissed');
    };
}]);
