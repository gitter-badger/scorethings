/**
 *
 * Created by manuisfunny on 3/28/15.
 */


angular.module('yeaskme', []).
    config(function() { })
    .controller('myCtrl', function($scope) {
        $scope.subjects = [
            "Get Hard",
            "John Mayer",
            "The Blues Brothers",
            "The Big Lebowski"
        ];
    });
