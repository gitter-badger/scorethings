angular.module('app').filter('thingType', function() {
    var typesToLabelsMap = {
        twitter_account: 'Twitter Account',
        github_repository: 'GitHub Repository',
        hashtag: 'Hashtag'
    };
    return function(thingType) {
        return typesToLabelsMap[thingType] || thingType;
    };
});