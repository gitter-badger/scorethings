angular.module('app').controller('ScoreListsDetailCtrl', ['$scope', '$stateParams', 'ScoreList', 'notifier', 'identity', 'addScoreToScoreListModalFactory', function($scope, $stateParams, ScoreList, notifier, identity, addScoreToScoreListModalFactory) {
    var scoreListId = $stateParams.scoreListId;

    $scope.isOwner = false;

    ScoreList.get(scoreListId).then(
        function successGet(scoreList) {
            console.log(scoreList);
            $scope.isOwner = (identity.userId == scoreList.user.id);
            $scope.scoreList = scoreList;
        },
        function errorGet(response) {
            notifier.error('failed to get scoreList');
            console.log(response);
        });
    $scope.updateScoreList = function() {
        new ScoreList($scope.scoreList).update().then(function (updatedScoreList) {
                notifier.success('updated score list: ' + updatedScoreList.name);
                $scope.scoreList = updatedScoreList;
            },
            function() {
                return notifier.error('failed to update score list');
            });
    };
    $scope.addScore = function() {
        addScoreToScoreListModalFactory.openModal($scope.scoreList, {closeOnSave: true},
            function saveSuccessCallbackFn(scoreList) {
                console.log('down here in score list detail, save success');
                console.log(response);
                $scope.scoreList = response;
        });
    };

    $scope.removeScore = function(score) {

    };
}]);