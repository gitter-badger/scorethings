angular.module('app').controller('AccountCriteriaCtrl', ['retrievedUserCriteria', '$scope', 'Criterion', '$modal', 'usSpinnerService', 'notifier', function(retrievedUserCriteria, $scope, Criterion, $modal, usSpinnerService, notifier) {
    $scope.criteria = retrievedUserCriteria;


    $scope.createNewCriterion = function() {
        var modalInstance = $modal.open({
            templateUrl: 'criteria/newCriterionModal.html',
            controller: 'NewCriterionModalCtrl',
            size: 'md'
        });

        modalInstance.result.then(
            function modalResult(newCriterion) {
                createCriterion(newCriterion);
            },
            function modalDismissed() {
            }
        );
    };

    function createCriterion(newCriterion) {
        usSpinnerService.spin('spinner-1');
        Criterion.post(newCriterion).then(
            function success(criterion) {
                usSpinnerService.stop('spinner-1');
                $scope.criteria.push(criterion)
            },
            function error(response) {
                usSpinnerService.stop('spinner-1');
                return notifier.error('failed to create criterion');
            })
    }
}]);
