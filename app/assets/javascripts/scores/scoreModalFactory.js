angular.module('app').factory('scoreModalFactory', ['$modal', function($modal) {
    return {
        createNewScoreForThing: function(thingInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/scoreModal.html',
                controller: 'CreateNewScoreModalCtrl',
                size: 'md',
                resolve: {
                    thingInput: function () {
                        return thingInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        },
        updateScore: function(scoreInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/scoreModal.html',
                controller: 'UpdateScoreModalCtrl',
                size: 'md',
                resolve: {
                    scoreInput: function () {
                        return scoreInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);