angular.module('app').controller('NewScoreCtrl', ['$scope', 'youtubeVideoUrlPattern', '$modal', '$location', 'Score', 'Restangular', 'usSpinnerService', 'twitter', 'notifier', 'scoreCategories', function($scope, youtubeVideoUrlPattern, $modal, $location, Score, Restangular, usSpinnerService, twitter, notifier, scoreCategories) {

    scoreCategories.getAll().then(
        function success(results) {
            $scope.scoreCategoriesMap = results.scoreCategoriesMap;
            $scope.generalScoreCategory = results.generalScoreCategory;
            $scope.score.score_category_id = $scope.generalScoreCategory.id;
        },
        function error(errorMsg) {
            notifier.error(errorMsg);
        }
    );

    $scope.setTab = function(thingType) {
        $scope.score.thing = {
            display_value: '',
            type: thingType,
            external_id: ''
        };
    };

    $scope.score = {};

    $scope.setTab('TWITTER_ACCOUNT');

    $scope.prefix = {
        TWITTER_ACCOUNT: '@',
        TWITTER_TWEET: 'Tweet',
        YOUTUBE_VIDEO: 'Video',
        HASHTAG: '#'
    };

    $scope.placeholders = {
        TWITTER_ACCOUNT: 'pattonoswalt   or   @pattonoswalt',
        TWITTER_TWEET: 'Example:  https://twitter.com/manuisfunny/status/599219499766718464',
        YOUTUBE_VIDEO: 'Example:  https://www.youtube.com/watch?v=B66feInucFY',
        HASHTAG: 'SomethingSomethingCats   or   #SomethingSomethingCats'
    };

    $scope.scoreCategoriesMap = {};



    $scope.scoreThing = function() {
        usSpinnerService.spin('spinner-1');
        if($scope.score.thing.type == 'TWITTER_ACCOUNT') {
            Restangular.one('thing_preview').getList('twitter_account', {input: $scope.thingInputValue})
                .then(function(thingPreviews) {
                    usSpinnerService.stop('spinner-1');
                    $scope.thingPreviews = thingPreviews;
                    console.log(thingPreviews);
                }, function(response) {
                    usSpinnerService.stop('spinner-1');
                    console.log('error retrieving thing previews');
                    console.log(response);
                });
        }
    };

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
                // user clicked a score category, so put that id in the score
                $scope.score.score_category_id = chosenScoreCategory.id;
            },
            function dismissed(result) {
            });
    };


}]);