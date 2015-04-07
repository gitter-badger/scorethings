angular.module('yeaskme').controller('SearchCtrl', ['$scope', '$http', function($scope, $http) {
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
                console.error(res);
            });
    };
}]);