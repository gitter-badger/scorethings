angular.module('app').factory('Criterion', ['railsResourceFactory', function(railsResourceFactory) {
    return railsResourceFactory({
        url: '/api/v1/criteria',
        name: 'criterion'
    })
}]);