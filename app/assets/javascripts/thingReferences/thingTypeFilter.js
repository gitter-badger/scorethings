angular.module('app').filter('thingType', function() {
    var typesToLabelsMap = {
        twitter_account: 'Twitter Account',
        youtube_video: 'YouTube Video',
        hashtag: 'Hashtag'
    };
    return function(thingType) {
        return typesToLabelsMap[thingType] || thingType;
    };
});