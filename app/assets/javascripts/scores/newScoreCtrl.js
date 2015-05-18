angular.module('app').controller('NewScoreCtrl', ['$window', '$scope', 'youtubeVideoUrlPattern', '$modal', '$location', 'Score', 'Restangular', 'usSpinnerService', 'twitter', 'notifier', 'scoreCategories', function($window, $scope, youtubeVideoUrlPattern, $modal, $location, Score, Restangular, usSpinnerService, twitter, notifier, scoreCategories) {
    $scope.thingInputValue = '';
    $scope.scoreCategories = [];

    $scope.setTab = function(thingType) {
        $scope.thingInputValue = '';
        $scope.score.thing = {
            disalay_value: '',
            type: thingType,
            external_id: ''
        };
        $scope.thingPreviews = [];
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

    $scope.findThingToScore = function() {
        usSpinnerService.spin('spinner-1');
        if($scope.score.thing.type == 'TWITTER_ACCOUNT') {
            Restangular.one('thing_preview').getList('twitter_account', {input: $scope.thingInputValue})
                .then(function(thingPreviews) {
                    usSpinnerService.stop('spinner-1');
                    $scope.thingPreviews = thingPreviews;
                }, function(response) {
                    usSpinnerService.stop('spinner-1');
                    console.log('error retrieving thing previews');
                    console.log(response);
                });
        }
    };


    $scope.scoreThing = function(thingPreview) {
        $modal.open({
            templateUrl: 'scores/scoreThingModal.html',
            controller: 'ScoreThingModalCtrl',
            size: 'md',
            resolve: {
                thingPreview: function() {
                    return thingPreview;
                }
            }
        }).result.then(
                function closed(score) {
                },
                function dismissed(result) {
                });
    };
}]);