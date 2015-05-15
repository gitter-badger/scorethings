angular.module('app').controller('NewScoreCtrl', ['$scope', 'youtubeVideoUrlPattern', '$modal', '$location', 'Score', 'usSpinnerService', 'twitter', 'notifier', 'scoreCategories', function($scope, youtubeVideoUrlPattern, $modal, $location, Score, usSpinnerService, twitter, notifier, scoreCategories) {

    scoreCategories.getAll().then(
        function success(results) {
            console.log('success');
            console.log(results);
            $scope.scoreCategoriesMap = results.scoreCategoriesMap;
            $scope.generalScoreCategory = results.generalScoreCategory;
            $scope.score.score_category_id = $scope.generalScoreCategory.id;
        },
        function error(errorMsg) {
            notifier.error(errorMsg);
        });
    $scope.setTab = function(thingType) {
        $scope.thingType = thingType;
        $scope.thingInputValue = '';
    };

    $scope.score = {};

    $scope.setTab('TWITTER_ACCOUNT');

    $scope.prefix = {
        TWITTER_ACCOUNT: '@',
        HASHTAG: '#'
    };

    $scope.examplePlaceholder = {
        TWITTER_ACCOUNT: 'pattonoswalt',
        YOUTUBE_VIDEO: 'Example:  https://www.youtube.com/watch?v=B66feInucFY',
        HASHTAG: 'SomethingSomethingCats'
    };

    $scope.scoreCategoriesMap = {};

    var numbers = new Bloodhound({
        datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.num); },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: '/api/v1/autocomplete/search?thing_type=' + $scope.thingType + '&query=%QUERY',
        wildcard: '%QUERY'
    });

    // initialize the bloodhound suggestion engine
    numbers.initialize();

    $scope.numbersDataset = {
        displayKey: 'num',
        source: numbers.ttAdapter()
    };

    $scope.exampleOptions = {
        highlight: true
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