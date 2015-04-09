angular.module('yeaskme')
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'main/index.html'
            }).
            when('/about', {
                templateUrl: 'main/about.html'
            }).
            when('/search', {
                templateUrl: 'search/index.html'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
