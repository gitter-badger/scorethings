angular.module('app').directive('pointsDial', function() {
    return {
        restrict: 'E',
        replace: true,
        require: 'ngModel',
        scope: {
            points: '='
        },
        template: '<input type="text" class="dial" step="1" data-min="0" data-max="100">',
        link: function($scope, $element, attrs, ngModel) {
            $element.knob({
                'release' : function (points) {
                    ngModel.$setViewValue(points);
                },
                'change' : function (points) {
                    ngModel.$setViewValue(points);
                }
            });

            // TODO change color when score category changes to have
            // different colors for different categories
            // use Dynamically configure 'configure' trigger
            // from https://github.com/aterrien/jQuery-Knob README
            $element.val($scope.points).trigger('change');
            $element.on('$destroy', function() { $element.off(); });
        }
    };
});
