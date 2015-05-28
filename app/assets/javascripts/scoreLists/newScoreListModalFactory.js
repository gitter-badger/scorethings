angular.module('app').factory('newScoreListModalFactory', ['$modal', 'notifier', function($modal, notifier) {
    return {
        openModal: function(saveSuccessCallbackFn) {
            var modalInstance = $modal.open({
                templateUrl: 'scoreLists/newScoreListModal.html',
                size: 'small',
                controller: ['$scope', '$modalInstance', 'ScoreList', function newScoreListModalCtrl($scope, $modalInstance, ScoreList){
                    $scope.scoreList = {};
                    $scope.save = function() {
                        new ScoreList($scope.scoreList).create()
                            .then(
                            function(createdScoreList) {
                                console.log(createdScoreList)
                                notifier.success('created score list: ' + createdScoreList.name);
                                saveSuccessCallbackFn(createdScoreList);
                                $scope.close();
                            },
                            function(response) {
                                notifier.error('failed to created score list');
                                console.log(response);
                            });
                    };

                    $scope.close = $scope.cancel = function() {
                        $modalInstance.dismiss();
                    };
                }]
            });

            modalInstance.result.then(saveSuccessCallbackFn);
        }
    };
}]);