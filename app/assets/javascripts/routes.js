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
            otherwise({
                redirectTo: '/'
            });
    }]);
