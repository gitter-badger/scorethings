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
                templateUrl: 'scores/scores.html'
            }).
                state('scores.search', {
                    url: '/search',
                    templateUrl: 'scores/scores.search.html',
                    controller: 'ScoresSearchCtrl',
                    reloadOnSearch : false
                }).
                state('scores.featured', {
                    url: '/featured',
                    templateUrl: 'scores/scores.featured.html',
                    controller: 'ScoresFeaturedCtrl'
                }).
                state('scores.scoreAThing', {
                    url: '/score_a_thing',
                    templateUrl: 'scores/scores.scoreAThing.html'
                }).
                state('scores.detail', {
                    url: '/:scoreId',
                    templateUrl: 'scores/scores.detail.html',
                    controller: 'ScoresDetailCtrl'
                }).

            /*
                 things
            */
            state('things', {
                url: '/things',
                templateUrl: 'things/things.html'
            }).
                state('things.search', {
                    url: '/search',
                    templateUrl: 'things/things.search.html',
                    reloadOnSearch : false
                }).
                state('things.featured', {
                    url: '/featured',
                    templateUrl: 'things/things.featured.html',
                    controller: 'ThingsFeaturedCtrl'
                }).
                state('things.detail', {
                    url: '/:thingId',
                    templateUrl: 'things/things.detail.html',
                    controller: 'ThingsDetailCtrl'
                }).
                state('things.detailScores', {
                    url: '/:thingId/scores',
                    templateUrl: 'things/things.detailScores.html',
                    controller: 'ThingsDetailScoresCtrl'
                }).
                state('things.detail.scores.new', {
                    url: '/new',
                    templateUrl: 'things/things.detail.scores.new.html',
                    controller: 'ThingsDetailScoresNewCtrl'
                }).

            /*
                 score lists
            */
            state('scoreLists', {
                url: '/score_lists',
                templateUrl: 'scoreLists/scoreLists.html',
                controller: 'ScoreListsMainCtrl'
            }).
                state('scoreLists.search', {
                    url: '/search',
                    templateUrl: 'scoreLists/scoreLists.search.html',
                    controller: 'ScoreListsCtrl'
                }).
                state('scoreLists.new', {
                    url: '/new',
                    templateUrl: 'scoreLists/scoreLists.new.html',
                    controller: 'ScoreListsNewCtrl'
                }).
                state('scoreLists.detail', {
                    url: '/:scoreListId',
                    templateUrl: 'scoreLists/scoreLists.detail.html',
                    controller: 'ScoreListsDetailCtrl'
                }).
                state('scoreLists.featured', {
                    url: '/featured',
                    templateUrl: 'scoreLists/scoreLists.featured.html',
                    controller: 'ScoreListsFeaturedCtrl'
                }).
                state('scoreLists.scorewars', {
                    url: '/scorewars',
                    templateUrl: 'scoreLists/scoreLists.scorewars.html',
                    controller: 'ScoreListsScorewarsCtrl'
                }).
                    state('scoreLists.detail.scores', {
                        url: '/scores',
                        templateUrl: 'scoreLists/scoreLists.detail.scores.html',
                        controller: 'ScoreListsDetailScoresCtrl'
                    }).
                    state('scoreLists.detail.scores.detail', {
                        url: '/:scoreId',
                        templateUrl: 'scoreLists/scoreLists.detail.scores.detail.html',
                        controller: 'ScoreListsDetailScoresDetailCtrl'
                    }).

            /*
                users
            */
            state('users', {
                url: '/users',
                templateUrl: 'users/users.html',
                controller: 'UsersMainCtrl'
            }).
                state('users.search', {
                    url: '/search',
                    templateUrl: 'users/users.search.html',
                    controller: 'UsersSearchCtrl'
                }).
                state('users.detail', {
                    url: '/:userId',
                    templateUrl: 'users/users.detail.html',
                    controller: 'UsersDetailCtrl'
                }).
                state('users.detail.scores', {
                    url: '/scores',
                    templateUrl: 'users/users.detail.scores.html',
                    controller: 'UsersDetailScoresCtrl'
                }).
                state('users.detail.scoreLists', {
                    url: '/score_lists',
                    templateUrl: 'users/users.detail.scoreLists.html',
                    controller: 'UsersDetailScoreListsCtrl'
                }).

            /*
             score categories
             */
            state('score_categories', {
                url: '/score_categories',
                templateUrl: 'scoreCategories/scoreCategories.html',
                controller: 'ScoreCategoriesCtrl'
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
            }).

        /*
         account
         */
        state('account', {
            url: '/account',
            templateUrl: 'account/account.html',
            controller: 'AccountMainCtrl'
        }).
            state('account.settings', {
                url: '/settings',
                templateUrl: 'account/account.settings.html',
                controller: 'AccountSettingsCtrl'
            });
    }]);
