angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.rule(function ($injector, $location) {
            //what this function returns will be set as the $location.url
            var path = $location.path(), normalized = path.toLowerCase();
            if (path != normalized) {
                //instead of returning a new url string, I'll just change the $location.path directly so I don't have to worry about constructing a new url string and so a new state change is not triggered
                $location.replace().path(normalized);
            }
            // because we've returned nothing, no state change occurs
        });
        $urlRouterProvider.otherwise('/');
        $stateProvider.
            state('home', {
                url: '/',
                templateUrl: 'main/home.html'
            }).
            /*
                 scores
            */
            state('scores', {
                url: '/scores',
                templateUrl: 'scores/scores.html',
                ncyBreadcrumb: {
                    label: 'Scores'
                }
            }).
                state('scores.scoreThing', {
                    url: '/score_thing',
                    templateUrl: 'scores/scores.scoreThing.html',
                    controller: 'ScoreThingCtrl'
                }).
                state('scores.show', {
                    url: '/:scoreId',
                    templateUrl: 'scores/scores.show.html',
                    controller: 'ShowScoreCtrl'
                }).

            /*
                 thing references
            */
            state('thingReferences', {
                url: '/thing_references',
                templateUrl: 'thingReferences/thingReferences.html'
            }).
                state('thingReferences.show', {
                    url: '/:thingReferenceId',
                    templateUrl: 'thingReferences/thingReferences.show.html',
                    controller: 'ThingReferencesShowCtrl'
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
                state('users.profile', {
                    url: '/profile/:username',
                    templateUrl: 'users/users.profile.html',
                    controller: 'UsersProfileCtrl'
                }).

            /*
             settings
             */
            state('settings', {
                url: '/settings',
                templateUrl: 'settings/settings.html',
                controller: 'SettingsCtrl'
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
            state('help.bugs', {
                url: '/bugs',
                templateUrl: 'help/help.bugs.html'
            }).
            state('help.donate', {
                url: '/donate',
                templateUrl: 'help/help.donate.html'
            });
    }]);
