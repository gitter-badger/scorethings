angular.module('app').config(['$routeProvider', function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'main/home.html'
            }).
            when('/faq', {
                templateUrl: 'faq/faq.html'
            }).
            when('/score_categories', {
                templateUrl: 'scoreCategories/scoreCategoryIndex.html',
                controller: 'ScoreCategoriesIndexCtrl'
            }).
            when('/account', {
                templateUrl: 'account/main.html',
                controller: 'AccountMainCtrl'
            }).
            when('/account/thing_suggestions', {
                templateUrl: 'account/thingSuggestions.html',
                controller: 'ThingSuggestionsCtrl'
            }).
            when('/scores/new', {
                templateUrl: 'scores/newScore.html',
                controller: 'NewScoreCtrl'
            }).
            when('/scores/:scoreId', {
                templateUrl: 'scores/showScore.html',
                controller: 'ShowScoreCtrl'
            }).
            when('/users/:userId/scores', {
                templateUrl: 'users/userScores.html',
                controller: 'UserScoresCtrl'
            }).
            when('/users/:userId', {
                templateUrl: 'users/main.html',
                controller: 'UserMainCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
