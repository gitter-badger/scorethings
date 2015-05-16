angular.module('app').directive('navCollapse', [function() {
    return {
        restrict: 'A',
        replace: false,
        link: function($scope, element, attrs) {
            /*
             quick hack
             copied from http://stackoverflow.com/a/16680604/4694250
             I'll try to come up with angularjs way of doing it later
             */
            $(element).on('click', function(){
                $(".navbar-toggle").click() //bootstrap 3.x by Richard
            });
        }
    };
}]);
