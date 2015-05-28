angular.module('app').filter('thingType', function() {
    var typesToLabelsMap = {
        twitter_account: 'Twitter Account',
        twitter_tweet: 'Twitter Tweet',
        youtube_video: 'YouTube Video',
        hashtag: 'Hashtag'
    };
    return function(thingType) {
        return typesToLabelsMap[thingType] || thingType;
    };
});