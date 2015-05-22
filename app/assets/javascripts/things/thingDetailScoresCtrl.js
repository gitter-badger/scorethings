angular.module('app').controller('ThingsDetailScoresCtrl', ['$window', '$scope', '$stateParams', 'Thing', 'notifier', function($window, $scope, $stateParams, Thing, notifier) {
    $window.Thing = Thing;
    var thingId = $stateParams.thingId;

    console.log(Thing);
    Thing.get(thingId + '/scores').then(
        function successGet(thing) {
            console.log(thing);
            $scope.thing = thing;
        },
        function errorGet(response) {
            notifier.error('failed to get thing');
            console.log(response);
        });
}]);
