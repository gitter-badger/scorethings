angular.module('app')
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'main/home.html',
                redirectTo: function(current, path, search){
                    // FIXME quick fix copy from, needs better solution
                    // http://omarriott.com/aux/angularjs-html5-routing-rails/
                    if(search.goto){
                        // if we were passed in a search param, and it has a path
                        // to redirect to, then redirect to that path
                        return "/" + search.goto
                    }
                    else{
                        // else just redirect back to this location
                        // angular is smart enough to only do this once.
                        return "/"
                    }
                }
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
