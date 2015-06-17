angular.module('app').controller('ThingCtrl', ['$scope', 'imageSearch', function($scope, imageSearch) {
    $scope.imageUrls = [];

    imageSearch.search($scope.thing.label, function(imageUrls) {
        $scope.imageUrls = imageUrls;
    });
}]);