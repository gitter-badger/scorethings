angular.module('yeaskme').controller('RateCtrl', ['$scope', '$routeParams', 'tmdbResource', function($scope, $routeParams, tmdbResource) {
    var subjectSource = $routeParams['subject_source'];
    var subjectId = $routeParams['subject_id'];
    console.log(subjectSource);

    if(subjectSource === 'tmdbMovie') {
        tmdbResource.movie(subjectId)
            .then(function success(data) {
                $scope.subject = data;
                console.log(data)
            });
    } else if(subjectSource === 'tmdbTV') {
        tmdbResource.tv(subjectId)
            .then(function success(data) {
                $scope.subject = data;
                console.log(data)
            });
    }
}]);
