angular.module('app').factory('ThingPreview', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/thing_previews',
        name: 'thing_preview'
    })
}]);
