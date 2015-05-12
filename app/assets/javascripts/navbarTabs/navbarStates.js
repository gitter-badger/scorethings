function navbarState(state, title, requiresLogin) {
    return {
        state: state,
        title: title,
        requiresLogin: requiresLogin
    };
}
angular.module('app').constant('NAVBAR_STATES', {
        SCORES: [
            navbarState('scores.new', 'New Score', true),
            navbarState('scores.search', 'Search Scores', false),
        ],
        ACCOUNT: [
            navbarState('account.settings', 'Settings', true),
            navbarState('account.scoreLists', 'Score Lists', true),
            navbarState('account.criteria', 'Criteria', true),
            navbarState('account.scores', 'Scores', true)
        ],
        ABOUT: [
            navbarState('about.scorethings', 'About scorethings', false),
            navbarState('about.contribute', 'Contribute', false),
            navbarState('about.connect', 'Connect', false),
        ]
    }
);
