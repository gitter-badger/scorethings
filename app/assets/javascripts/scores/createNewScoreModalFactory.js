angular.module('app').factory('createNewScoreModalFactory', ['$modal', function($modal) {
    return {
        createNewScoreForThing: function(thingReferenceInput, thingInput, imagesInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/createNewScoreModal.html',
                controller: 'CreateNewScoreModalCtrl',
                size: 'sm',
                resolve: {
                    thingReferenceInput: function () {
                        return thingReferenceInput;
                    },
                    imagesInput: function () {
                        return imagesInput;
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