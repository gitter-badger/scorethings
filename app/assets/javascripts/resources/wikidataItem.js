angular.module('app').factory('WikidataItem', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/wikidata_items',
        name: 'wikidata_item'
    });
}]);
