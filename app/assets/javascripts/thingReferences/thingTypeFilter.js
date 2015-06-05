angular.module('app').filter('thingType', function() {
    var typesToLabelsMap = {
        twitter_account: 'Twitter Account',
        github_repository: 'GitHub Repository',
        soundcloud_track: 'Soundcloud Track',
        tmdb_movie: 'TMDb Movie',
        tmdb_tv: 'TMDb TV Show',
        hashtag: 'Hashtag'
    };
    return function(thingType) {
        return typesToLabelsMap[thingType] || thingType;
    };
});