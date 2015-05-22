angular.module('app').controller('ThingsDetailCtrl', ['$scope', '$stateParams', 'Thing', 'notifier', function($scope, $stateParams, Thing, notifier) {
    var thingId = $stateParams.thingId;

    Thing.get(thingId).then(
        function successGet(thing) {
            console.log(thing);
            $scope.thing = thing;
        },
        function errorGet(response) {
            notifier.error('failed to get thing');
            console.log(response);
        });
}]);