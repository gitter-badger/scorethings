angular.module('app').directive('scoreCategoryPanel', [function() {
    return {
        restrict: 'E',
        replace: true,
        scope: {
            scoreCategory: '=',
            disabled: '=?',
            hideDescription: '=?'
        },
        templateUrl: 'scoreCategories/scoreCategoryPanel.html',
        link: function($scope, element, attrs) {
        }
    };
}]);
