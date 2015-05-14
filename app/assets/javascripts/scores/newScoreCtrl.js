angular.module('app').controller('NewScoreCtrl', ['youtubeVideoUrlPattern', '$scope', '$location', 'Score', 'usSpinnerService', 'twitter', 'notifier', '$http', function(youtubeVideoUrlPattern, $scope, $location, Score, usSpinnerService, twitter, notifier, $http) {
    $scope.scoreCategoriesMap = {};

    $scope.newScore = {

    };

    $http.get('/api/v1/score_categories', null, {cached: true})
        .then(function(response) {
            if(response.errors) {
                notifier.error('failed to get score categories');
                console.log(response.errors);
                return;
            } else if(!response.data || !response.data.score_categories) {
                notifier.error('score category data was not formatted correctly');
                console.log(response);
                return;
            }

            $scope.scoreCategoriesMap = {};

            var scoreCategories = response.data.score_categories;

            angular.forEach(scoreCategories, function(scoreCategory) {
                if(scoreCategory.general) {
                    $scope.newScore.score_category_id = scoreCategory.id;
                }
                $scope.scoreCategoriesMap[scoreCategory.id] = scoreCategory;
            });
        });

    $scope.scoreThing = function() {
        console.log('scoring something');
    };

}]);