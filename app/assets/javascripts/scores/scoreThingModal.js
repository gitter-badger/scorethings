angular.module('app').controller('ScoreThingModalCtrl', ['$scope', '$modalInstance', 'Restangular', 'thing', 'scoreCategories', 'notifier', function($scope, $modalInstance, Restangular, thing, scoreCategories, notifier) {
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
        var scores = Restangular.all('scores');
        scores.post($scope.score).then(function(response) {
            $modalInstance.close(response.score);
        }, function(response) {
            $modalInstance.dismiss({error: response});
        });
    };

    $scope.cancel = function() {
        $modalInstance.dismiss('now dismissed');
    };
}]);
