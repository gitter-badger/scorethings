angular.module('app').controller('NewCriterionModalCtrl', ['$scope', '$modalInstance', function ($scope, $modalInstance) {
    $scope.newCriterion = {
        sign: 1
    };

    $scope.create = function () {
        $modalInstance.close($scope.newCriterion);
    };

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };
}]);