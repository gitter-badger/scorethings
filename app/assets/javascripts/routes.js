angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
        $stateProvider.
            state('home', {
                url: '/',
                templateUrl: 'main/home.html'
            }).
            state('stem', {
                url: '/stem',
                templateUrl: 'main/stem.html'
            }).
            /*
                 scores
            */
            state('scores', {
                url: '/scores',
                templateUrl: 'scores/scores.html'
            }).
                state('scores.search', {
                    url: '/search?query',
                    templateUrl: 'scores/scores.search.html',
                    controller: 'ScoresSearchCtrl'
                }).
                state('scores.new', {
                    url: '/new?thingId&criterion',
                    templateUrl: 'scores/scores.new.html',
                    controller: 'NewScoreCtrl'
                }).
                state('scores.show', {
                    url: '/:scoreId',
                    templateUrl: 'scores/scores.show.html',
                    controller: 'ShowScoreCtrl'
                }).

            /*
             things
             */
            state('things', {
                url: '/things',
                abstract: true,
                templateUrl: 'things/things.html'
            }).
                state('things.search', {
                    url: '/search?query',
                    templateUrl: 'things/things.search.html',
                    controller: 'ThingsSearchCtrl'
                }).
            /*
             scored scoredThings
            */
            state('scoredThings', {
                url: '/scoredThings',
                abstract: true,
                templateUrl: 'scoredThings/scoredThings.html'
            }).
                state('scoredThings.show', {
                    url: '/:scoredThingId',
                    templateUrl: 'scoredThings/scoredThings.show.html',
                    controller: 'ShowScoredThingsCtrl'
                }).
                    state('scoredThings.show.scores', {
                        url: '/scores',
                        templateUrl: 'scoredThings/scoredThings.show.scores.html',
                        controller: 'ShowScoredThingsScoresCtrl'
                    }).

            /*
                 about
            */
            state('about', {
                url: '/about',
                templateUrl: 'about/about.html'
            }).
                state('about.scorethings', {
                    url: '/scorethings',
                    templateUrl: 'about/about.scorethings.html'
                }).
            /*
             users
             */
            state('users', {
                url: '/users',
                templateUrl: 'users/users.html'
            }).
                state('users.edit', {
                    url: '/edit',
                    templateUrl: 'users/users.edit.html',
                    controller: 'UsersEditCtrl'
                }).
                state('users.search', {
                    url: '/search',
                    templateUrl: 'users/users.search.html',
                    controller: 'UsersSearchCtrl'
                }).
                state('users.show', {
                    url: '/:username',
                    templateUrl: 'users/users.show.html',
                    controller: 'UsersShowCtrl'
                }).

            /*
             Help
             */
            state('help', {
                url: '/help',
                templateUrl: 'help/help.html'
            }).
            state('help.documentation', {
                url: '/documentation',
                templateUrl: 'help/help.documentation.html'
            }).
            state('help.feedback', {
                url: '/feedback',
                templateUrl: 'help/help.feedback.html'
            }).
            state('help.features', {
                url: '/features',
                templateUrl: 'help/help.features.html'
            }).
            state('help.bugs', {
                url: '/bugs',
                templateUrl: 'help/help.bugs.html'
            }).
            state('help.faq', {
                url: '/faq',
                templateUrl: 'help/help.faq.html'
            });
}]);
