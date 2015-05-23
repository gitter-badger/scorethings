angular.module('app').factory('scoreModalFactory', ['$modal', 'scoreCategoriesData', function($modal, scoreCategoriesData) {
    return {
        openModal: function(scoreInput, handleResultFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scores/scoreModal.html',
                controller: 'ScoreModalCtrl',
                size: 'md',
                resolve: {
                    scoreInput: function () {
                        return scoreInput;
                    },
                    scoreCategoriesInput: function() {
                        var scoreCategories = scoreCategoriesData.get();
                        return scoreCategories;
                    }
                }
            });

            modalInstance.result.then(handleResultFn);
        }
    };
}]);