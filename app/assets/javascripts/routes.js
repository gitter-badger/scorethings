angular.module('app')
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'main/home.html'
            }).
            when('/about', {
                templateUrl: 'main/about.html'
            }).
            when('/scores/new', {
                templateUrl: 'scores/newScore.html',
                controller: 'NewScoreCtrl'
            }).
            when('/scores/:scoreId', {
                templateUrl: 'scores/showScore.html',
                controller: 'ShowScoreCtrl'
            }).
            when('/scores', {
                templateUrl: 'scores/scoreIndex.html',
                controller: 'ScoreIndexCtrl'
            }).
            when('/about', {
                templateUrl: 'about/main.html'
            }).
            when('/about/contribute', {
                templateUrl: 'about/contribute.html'
            }).
            when('/about/connect', {
                templateUrl: 'about/connect.html'
            }).
            when('/account', {
                templateUrl: 'account/main.html'
            }).
            when('/account/scores', {
                templateUrl: 'account/scores.html'
            }).
            when('/account/score_lists', {
                templateUrl: 'account/score_lists.html'
            }).
            when('/account/criteria', {
                templateUrl: 'account/criteria.html'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
