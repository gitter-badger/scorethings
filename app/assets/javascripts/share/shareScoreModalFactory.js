angular.module('app').factory('shareScoreModalFactory', ['$modal', 'shareText', '$state', function($modal, shareText, $state) {
    return {
        shareNewScore: function(thing, criterion) {
            if(!thing) {
                console.error('cannot open share modal without thing');
                return;
            }

            $modal.open({
                templateUrl: 'share/shareScoreModal.html',
                controller: ['$scope', '$modalInstance', 'thing', 'criterion', function($scope, $modalInstance, thing, criterion) {
                    $scope.close = function() {
                        $modalInstance.close();
                    };

                    var thingTitle = thing.title;
                    var criterionName = criterion && criterion.name;

                    $scope.text = shareText.generateNewScoreText(thingTitle, criterionName);
                    $scope.title = shareText.generateNewScoreTitle(thingTitle, criterionName);
                    $scope.url = $state.href('scores.new', {thingId: thing.id}, {absolute: true});
                }],
                size: 'sm',
                resolve: {
                    thing: function() {
                        return thing;
                    },
                    criterion: function() {
                        return criterion;
                    }
                }
            });
        },
        shareCreatedScore: function(score) {
            if(!score) {
                console.error('cannot open share modal without score');
                return;
            }

            $modal.open({
                templateUrl: 'share/shareScoreModal.html',
                controller: ['$scope', '$modalInstance', 'score', function($scope, $modalInstance, score) {
                    $scope.close = function() {
                        $modalInstance.close();
                    };

                    $scope.text = shareText.generateCreatedScoreText(score);
                    $scope.title = shareText.generateCreatedScoreTitle(score);
                    $scope.url = $state.href('scores.show', {scoreId: score.token}, {absolute: true});
                }],
                size: 'sm',
                resolve: {
                    score: function() {
                        return score;
                    }
                }
            });
        }
    }

}]);
