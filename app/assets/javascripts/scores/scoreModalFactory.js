angular.module('app').factory('scoreModalFactory', ['$modal', function($modal) {
    return {
        createNewScoreForThing: function(thingReferenceInput, thingInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/createNewScoreModal.html',
                controller: 'CreateNewScoreModalCtrl',
                size: 'md',
                resolve: {
                    thingReferenceInput: function () {
                        return thingReferenceInput;
                    },
                    thingInput: function () {
                        return thingInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);