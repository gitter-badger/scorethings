var twitter, $httpBackend;

describe('twitter', function() {
    // simple spec to get jasmine tests started, may be unnecessary

    // TODO figure out how to deal with 'templates' module
    angular.module('templates', []);
    beforeEach(module('app'));
    beforeEach(inject(function($injector) {
        twitter = $injector.get('twitter');
        $httpBackend = $injector.get('$httpBackend');
    }));

    describe('searching for twitter accounts by handle', function() {
        it('should search for twitter accounts by handle', function() {
            var expectedTwitterAPIGET = '/api/v1/things/search?twitter_handle=pattonoswalt';
            var fixtureData = readJSON('./fixtures/twitterSearchResultsEmpty.json');
            $httpBackend.expectGET(expectedTwitterAPIGET).respond(fixtureData);
            twitter.searchTwitterHandles('pattonoswalt',
                function success(response) {
                    // TODO figure out the right way to test fixture and response
                    // pass javascript object into toEqual to actually test correct?
                    expect(response).toEqual(fixtureData);
                },
                function error(errors) {
                    // there shouldn't be errors
                    expect(1).toBe(2);
                });
            $httpBackend.flush();
        });
    });
});