angular.module('app').factory('scoreModalFactory', ['$modal', function($modal) {
    return {
        createNewScoreForThing: function(thingInput, webThingInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/createNewScoreModal.html',
                controller: 'CreateNewScoreModalCtrl',
                size: 'md',
                resolve: {
                    thingInput: function () {
                        return thingInput;
                    },
                    webThingInput: function () {
                        return webThingInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);