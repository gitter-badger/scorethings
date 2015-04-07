angular.module('yeaskme').controller('SearchCtrl', ['$scope', '$http', 'notifier', function($scope, $http, notifier) {
    $scope.submitSearch = function() {
        $scope.searchResults = [];

        $http.get('/search', {
            params: {
                search_term: $scope.searchTerm
            }})
            .success(function(data) {
                $scope.searchResults = data;
            })
            .error(function(res) {
                notifier.error('Failed to search for ' + $scope.searchTerm);
            });
    };
}]);