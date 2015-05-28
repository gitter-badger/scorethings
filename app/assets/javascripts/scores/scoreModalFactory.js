angular.module('app').factory('scoreModalFactory', ['$modal', 'scoreCategoriesData', function($modal, scoreCategoriesData) {
    return {
        openModal: function(scoreInput, options, saveSuccessCallbackFn) {
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
                    },
                    scoreCategoriesInput: function() {
                        var scoreCategories = scoreCategoriesData.get();
                        return scoreCategories;
                    },
                    saveSuccessCallbackFn: function() {
                        return saveSuccessCallbackFn;
                    },
                    options: function() {
                        return options;
                    }
                }
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);