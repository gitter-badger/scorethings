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
            when('/score_lists/new', {
                templateUrl: 'scoreLists/newScoreList.html',
                controller: 'NewScoreListCtrl'
            }).
            when('/score_lists/:scoreListId', {
                templateUrl: 'scoreLists/showScoreList.html',
                controller: 'ShowScoreListCtrl'
            }).
            when('/users/:userId/scores', {
                templateUrl: 'users/userScores.html',
                controller: 'UserScoresCtrl'
            }).
            when('/users/:userId', {
                templateUrl: 'users/main.html',
                controller: 'UserMainCtrl'
            }).
            when('/about', {
                templateUrl: 'about/scorethings.html'
            }).
            when('/about/donate', {
                templateUrl: 'about/aboutDonate.html'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
