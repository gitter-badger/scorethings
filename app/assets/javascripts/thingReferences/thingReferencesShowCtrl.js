angular.module('app').controller('ThingReferencesShowCtrl', ['$scope', '$stateParams', 'ThingReference', 'notifier', 'createNewScoreModalFactory', '$state', function($scope, $stateParams, ThingReference, notifier, createNewScoreModalFactory, $state) {
    var thingReferenceId = $stateParams.thingReferenceId;

    ThingReference.get(thingReferenceId).then(
        function successGet(thingReference) {
            $scope.thingReference = thingReference;
            $scope.thing = thingReference.thing;
        },
        function errorGet(response) {
            notifier.error('failed to get thing_reference');
            console.log(response);
        });
}]);