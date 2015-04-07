angular.module('yeaskme')
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'main/search.html'
            }).
            when('/about', {
                templateUrl: 'main/about.html'
            }).
            when('/search', {
                templateUrl: 'search/search.html',
                controller: 'SearchCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
