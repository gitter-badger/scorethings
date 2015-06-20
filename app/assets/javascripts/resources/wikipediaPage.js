angular.module('app').factory('WikipediaPage', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/wikipedia_pages',
        name: 'wikipedia_page'
    });
}]);
