angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'Score', 'usSpinnerService', 'twitter', 'notifier', function($scope, $location, Score, usSpinnerService, twitter, notifier) {
    $scope.thing = {};

    $scope.placeholder = '';

    $scope.active = {
        TWITTER_UID: true
    };

    function switchThingType(type, placeholder, prefix) {
        $scope.thing = {
            value: '',
            type: type
        };
        $scope.placeholder = placeholder;
        $scope.prefix = prefix;
        $scope.activateTab(type);
    }

    $scope.activateTab = function(tab) {
        // copied from https://github.com/angular-ui/bootstrap/issues/611#issuecomment-70339233
        $scope.active = {}; //reset
        $scope.active[tab] = true;
    };

    $scope.setThingTypeToTwitterAccount = function() {
        switchThingType('TWITTER_UID', 'Example:   stevedildarian', '@');
    };
    $scope.setThingTypeToYouTubeVideo = function() {
        switchThingType('YOUTUBE_VIDEO', 'Example:   https://www.youtube.com/watch?v=zFMRn-TZVGg');
    };
    $scope.setThingTypeToHashtag = function() {
        switchThingType('HASHTAG', 'Example:   stuballs', '#');
    };

    // Default to twitter account
    $scope.setThingTypeToTwitterAccount();

    $scope.scoreThing = function() {
        console.log($scope.thing);
    };
}]);