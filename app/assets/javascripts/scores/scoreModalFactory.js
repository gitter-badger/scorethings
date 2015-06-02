angular.module('app').factory('scoreModalFactory', ['$modal', function($modal) {
    return {
        createNewScoreForThing: function(thingInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/createScoreModal.html',
                controller: 'CreateNewScoreModalCtrl',
                size: 'md',
                resolve: {
                    thingInput: function () {
                        return thingInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);