describe('scores', function() {
    // FIXME figure out how to run protractor e2e with twitter oauth
    it('should create a new score for a twitter hashtag', function () {
        browser.get('/');
        expect(!element(by.id('currentUserTwitterHandle')).isDisplayed());
        element(by.id('loginTwitter')).click();
        browser.sleep(1000);

        expect(element(by.id('currentUserTwitterHandle')).isDisplayed());
        browser.sleep(9000);

        element(by.id('scoreAThing')).click();
        element(by.model('thingInputValue')).sendKeys('#MyCoolHashtag');
        expect(element(by.id('createScore')).isDisplayed());
        element(by.id('createScore')).click();
        browser.sleep(1000);
        expect(element(by.id('twitterHashtag')).isDisplayed());
        expect(element(by.id('twitterHashtag')).getText()).toEqual('This should not be.');
    });
    // TODO add more anonymous tests (duh)
});