angular.module('app').directive('scoreInputForm', ['$modal', function($modal) {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            score: '=',
            prefix: '=',
            examplePlaceholder: '=',
            scoreCategoriesMap: '='
        },
        templateUrl: 'scores/scoreInputForm.html',
        link: function($scope, element, attrs) {

            $scope.scoreThing = function() {
                console.log($scope.score);
            };

            $scope.chosenScoreCategory = {};

            $scope.$watch('score.score_category_id', function(scoreCategoryId) {
                if(!scoreCategoryId) {
                    return;
                }

                $scope.chosenScoreCategory =  $scope.scoreCategoriesMap[scoreCategoryId];
            });


            $scope.chooseScoreCategory = function() {
                $modal.open({
                    templateUrl: 'scores/chooseScoreCategoryModal.html',
                    size: 'md',
                    controller: function($scope, $modalInstance, scoreCategoriesMap, chosenScoreCategory) {
                        $scope.scoreCategoriesMap = scoreCategoriesMap;
                        $scope.chosenScoreCategory = chosenScoreCategory;

                        $scope.chooseScoreCategory = function(scoreCategory) {
                            $modalInstance.close(scoreCategory);
                        };
                        $scope.cancel = function() {
                            $modalInstance.dismiss('now dismissed');
                        };
                    },
                    resolve: {
                        scoreCategoriesMap: function() {
                            return $scope.scoreCategoriesMap;
                        },
                        chosenScoreCategory: function() {
                            return $scope.chosenScoreCategory;
                        }
                    }
                })
                .result.then(
                    function closed(chosenScoreCategory) {
                        $scope.score.score_category_id = chosenScoreCategory.id;
                    },
                    function dismissed(result) {
                    });
            };
        }
    };
}]);
