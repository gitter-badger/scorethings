angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider.
        state('root', {
            url: '/',
            templateUrl: 'main/home.html'
        }).
        state('scores', {
            url: '/scores',
            templateUrl: 'scores/scores.main.html',
            controller: 'ScoresMainCtrl',
            ncyBreadcrumb: {
                label: 'Scores'
            }
        }).
            state('scores.search', {
                url: '/search',
                templateUrl: 'scores/scores.search.html',
                controller: 'SearchScoreCtrl',
                ncyBreadcrumb: {
                    label: 'Search'
                }
            }).
            state('scores.new', {
                url: '/new',
                templateUrl: 'scores/scores.new.html',
                controller: 'NewScoreCtrl',
                ncyBreadcrumb: {
                    label: 'New'
                }
            }).
            state('scores.show', {
                url: '/:scoreId',
                templateUrl: 'scores/scores.show.html',
                controller: 'ShowScoreCtrl',
                ncyBreadcrumb: {
                    label: 'Score Details'
                }
            }).
        state('about', {
            url: '/about',
            templateUrl: 'about/about.main.html',
            controller: 'AboutMainCtrl'
        }).
            state('about.contribute', {
                url: '/contribute',
                templateUrl: 'about/about.contribute.html'
            }).
            state('about.scorethings', {
                url: '/scorethings',
                templateUrl: 'about/about.scorethings.html'
            }).
            state('about.connect', {
                url: '/connect',
                templateUrl: 'about/about.connect.html'

            }).
        state('account', {
            url: '/account',
            templateUrl: 'account/account.main.html',
            controller: 'AccountMainCtrl',
            ncyBreadcrumb: {
                label: 'Account'
            }
        }).
            state('account.settings', {
                url: '/info',
                templateUrl: 'account/account.settings.html',
                ncyBreadcrumb: {
                    label: 'Settings'
                }
            }).
            state('account.scores', {
                url: '/scores',
                templateUrl: 'account/account.scores.html',
                controller: 'AccountScoresCtrl',
                ncyBreadcrumb: {
                    label: 'Your Scores'
                }
            }).
            state('account.scoreLists', {
                url: '/scoreLists',
                templateUrl: 'account/account.scoreLists.html',
                ncyBreadcrumb: {
                    label: 'Your Score Lists'
                }
            }).
            state('account.criteria', {
                url: '/criteria',
                templateUrl: 'account/account.criteria.html',
                controller: 'AccountCriteriaCtrl',
                resolve: {
                    retrievedUserCriteria: ['UserCriteria', function(UserCriteria) {
                        return UserCriteria.getList().then(
                            function successRetrievingUserCriteria(response) {
                                return response;
                            },
                            function errorRetrievingUserCriteria(response) {
                                console.log(response)
                                return;
                            }
                        );
                    }]
                },
                ncyBreadcrumb: {
                    label: 'Your Criteria'
                }
            }).
                state('account.criteria.detail', {
                    url: '/:criteriaId',
                    templateUrl: 'account/criteria/criterion.detail.html',
                    ncyBreadcrumb: {
                        label: 'Criterion'
                    }
                }).
                state('account.criteria.detail.level', {
                    url: '/levels/:criterionLevelId',
                    templateUrl: 'account/criteria/criterion.level.detail.html',
                    ncyBreadcrumb: {
                        label: 'Criterion Level'
                    }
                });
}]);
