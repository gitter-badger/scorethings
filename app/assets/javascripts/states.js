angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/');

    $stateProvider.
        state('root', {
            url: '/',
            templateUrl: 'main/home.html'
        }).
        state('about', {
            url: '/about',
            templateUrl: 'about/about.main.html',
            controller: 'AboutCtrl'
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
            controller: 'AccountCtrl'
        }).
        state('account.scores', {
            url: '/scores',
            templateUrl: 'account/account.scores.html'
        }).
        state('account.scoreLists', {
            url: '/scoreLists',
            templateUrl: 'account/account.scoreLists.html'
        }).
        state('account.criteria', {
            url: '/criteria',
            templateUrl: 'account/account.criteria.html'
        });
}]);
