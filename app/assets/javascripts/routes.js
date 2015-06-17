angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
        $urlRouterProvider.rule(function ($injector, $location) {
            //what this function returns will be set as the $location.url
            var goto = $location.$$search.goto;
            if(goto) {
                $location.path('/' + goto);
                $location.search('goto', null);
            }
        });
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
                    controller: 'SearchScoresCtrl'
                }).
                state('scores.show', {
                    url: '/:scoreId',
                    templateUrl: 'scores/scores.show.html',
                    controller: 'ShowScoreCtrl'
                }).
                    state('scores.show.edit', {
                        url: '/edit',
                        templateUrl: 'scores/scores.show.edit.html',
                        controller: 'EditScoreCtrl'
                    }).

            /*
             things
            */
            state('things', {
                url: '/things', // example: /things
                templateUrl: 'things/things.html'
            }).
                state('things.search', {
                    url: '/search', // example: /things/search
                    templateUrl: 'things/things.search.html',
                    controller: 'ThingsSearchCtrl'
                }).
                state('things.show', {
                    url: '/t/:dbpediaResourceName', // example: /things/t/Patton_Oswalt
                    templateUrl: 'things/things.show.html',
                    controller: 'ThingsShowCtrl'
                }).
                    state('things.show.scores', {
                        url: '/scores', // example: /things/t/Patton_Oswalt/scores
                        templateUrl: 'things/things.show.scores.html',
                        controller: 'ThingsScoresCtrl'
                    }).
                        state('things.show.scores.new', {
                            url: '/new', // example: /things/t/Patton_Oswalt/scores/new
                            templateUrl: 'things/things.scores.new.html',
                            controller: 'ThingsNewScoreCtrl'
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
            }).
            state('help.donate', {
                url: '/donate',
                templateUrl: 'help/help.donate.html'
            });
}]);
