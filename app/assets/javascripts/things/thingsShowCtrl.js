angular.module('app').controller('ThingsShowCtrl', ['$scope', '$stateParams', 'Thing', 'notifier', function($scope, $stateParams, Thing, notifier) {
    var thingId = $stateParams.thingId;

    Thing.get(thingId).then(
        function successfulGetThing(response) {
            $scope.thing = response.thing;
        },
        function unsuccessfulGetThing(response) {
            notifier.error('failed to get thing');
        });
}]);