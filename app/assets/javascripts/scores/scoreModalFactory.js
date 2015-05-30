angular.module('app').factory('scoreModalFactory', ['$modal', function($modal) {
    return {
        openModal: function(scoreInput, saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/scoreModal.html',
                controller: 'ScoreModalCtrl',
                size: 'md',
                resolve: {
                    scoreInput: function () {
                        console.log(scoreInput);
                        if(!scoreInput) {
                            console.error('scoreInput into score modal openModal is null');
                        }
                        return scoreInput;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);