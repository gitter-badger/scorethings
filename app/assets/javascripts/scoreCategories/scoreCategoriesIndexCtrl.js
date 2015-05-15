angular.module('app').controller('ScoreCategoriesIndexCtrl', ['$scope', '$http', 'notifier', function($scope, $http, notifier) {
    $scope.scoreCategories = [];

    $http.get('/api/v1/score_categories', null, {cached: true}).then(
        function(response) {
            if(response.errors) {
                notifier.error('failed to get categories');
                console.log(response.errors);
                return;
            }

            var data = response.data;
            $scope.scoreCategories = data.score_categories;
        });
}]);