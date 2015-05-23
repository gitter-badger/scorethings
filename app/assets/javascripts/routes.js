angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
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
                    controller: 'ScoresSearchCtrl'
                }).
                state('scores.featured', {
                    url: '/featured',
                    templateUrl: 'scores/scores.featured.html',
                    controller: 'ScoresFeaturedCtrl'
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
                    controller: 'ThingsSearchCtrl'
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
                url: '/scoreLists',
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
                state('scoreLists.detail', {
                    url: '/:scoreListId',
                    templateUrl: 'scoreLists/scoreLists.detail.html',
                    controller: 'ScoreListsDetailCtrl'
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
                Help
             */
            state('help', {
                url: '/help',
                templateUrl: 'help/help.html'
            }).
                state('help.howTo', {
                    url: '/howTo',
                    templateUrl: 'help/help.howTo.html'
                }).
                state('help.videos', {
                    url: '/videos',
                    templateUrl: 'help/help.videos.html'
                }).
                state('help.faq', {
                    url: '/faq',
                    templateUrl: 'help/help.faq.html'
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
                    url: '/scoreLists',
                    templateUrl: 'users/users.detail.scoreLists.html',
                    controller: 'UsersDetailScoreListsCtrl'
                }).

            /*
             score categories
             */
            state('score_categories', {
                url: '/score_categories',
                templateUrl: 'scoreCategories/scoreCategoryIndex.html',
                controller: 'ScoreCategoriesIndexCtrl'
            }).

            /*
                 about
            */
            state('about', {
                url: '/about',
                templateUrl: 'about/about.html',
                controller: 'AboutCtrl'
            }).

            /*
                 contribute
            */
            state('contribute', {
                url: '/contribute',
                templateUrl: 'contribute/contribute.html'
            }).
            state('contribute.help', {
                url: '/help',
                templateUrl: 'contribute/contribute.help.html'
            }).
            state('contribute.feedback', {
                url: '/feedback',
                templateUrl: 'contribute/contribute.feedback.html'
            }).
            state('contribute.bugs', {
                url: '/bugs',
                templateUrl: 'contribute/contribute.bugs.html'
            }).
            state('contribute.features', {
                url: '/features',
                templateUrl: 'contribute/contribute.features.html'
            }).
            state('contribute.donate', {
                url: '/donate',
                templateUrl: 'contribute/contribute.donate.html'
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
