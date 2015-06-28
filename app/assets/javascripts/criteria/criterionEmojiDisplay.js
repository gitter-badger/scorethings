angular.module('app').directive('criterionEmojiDisplay', function() {
    return {
        restrict: 'E',
        replace: true,
        templateUrl: 'criteria/criterionEmojiDisplay.html',
        scope: {
            criterion: '=?'
        },
        link: function($scope) {
            $scope.criterionEmoji = null;

            $scope.$watch('criterion', function(newCriterionValue) {
                $scope.criterionEmoji = (newCriterionValue && newCriterionValue.emoji);
            });
        }
    };
});
