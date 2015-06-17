angular.module('app').controller('ThingsShowCtrl', ['$scope', '$stateParams', 'Thing', 'DbpediaThing', function($scope, $stateParams, Thing, DbpediaThing) {
    var dbpediaResourceName = $stateParams.dbpediaResourceName;

    var NOT_FOUND_STATUS = 404;

    Thing.get(dbpediaResourceName).then(
        function successful(thing) {
            $scope.thing = thing;
            console.log(thing);
        }, function unsuccessful(response) {
            if(response.status == NOT_FOUND_STATUS) {
                DbpediaThing.get(dbpediaResourceName).then(
                    function successful(response) {
                        console.log(response);
                        $scope.dbpediaThing = response.dbpediaThing;
                    },
                    function unsuccessful(response) {
                        console.error('failed to get dbpedia thing');
                    }
                );
            }
        });
}]);