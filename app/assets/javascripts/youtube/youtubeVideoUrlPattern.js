angular.module('app').constant('youtubeVideoUrlPattern',
    // copied from https://gist.github.com/afeld/1254889
    /(youtu.be\/|youtube.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&\"\'>]+)/
);