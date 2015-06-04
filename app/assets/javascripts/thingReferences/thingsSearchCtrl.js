angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'Thing', 'scoreModalFactory', 'notifier', '$stateParams', '$state', '$location', function($scope, Thing, scoreModalFactory, notifier, $stateParams, $state, $location) {
    $scope.showNoResultsMessage = false;
    handleQueryParams($location.$$search);

    function handleQueryParams(params) {
        if(!params) return;

        $scope.query = params.query;
        $scope.selectedType = params.type || 'twitter_account';
        if(params.query && params.type) {
            searchThings();
        }
    }

    function type(label, examplePlaceholder) {
        return {
            label: label,
            examplePlaceholder: examplePlaceholder && ('Example: ' + examplePlaceholder)
        };
    }
    $scope.types = {
        twitter_account: type('Twitter Account', 'Patton Oswalt, @pattonoswalt, pattonoswalt, or https://twitter.com/pattonoswalt'),
        youtube_video: type('YouTube Video', 'Cat Stuff or https://www.youtube.com/watch?v=B66feInucFY'),
        hashtag: type('Hashtag', '#SomethingCats or SomethingCats')
    };


    $scope.$watch('selectedType', function() {
        $scope.things = [];
        $scope.showNoResultsMessage = false;
    });

    $scope.$watch('query', function() {
        $scope.showNoResultsMessage = false;
    });

    $scope.scoreThing = function(thing) {
        scoreModalFactory.createNewScoreForThing({}, thing,
            function saveSuccessCallbackFn(createdScore) {
                console.log(createdScore);
                notifier.success('you scored the thing: ' + thing.title);
                $state.go('scores.show', {scoreId: createdScore.token});
            },
            function saveErrorCallbackFn() {
                notifier.error('failed to score the thing: ' + thing.title);
                return;
            });
    };

    $scope.scoreHashtagQuery = function() {
        var hashtagExternalId = stripPrefix($scope.query);
        $scope.scoreThing({
            externalId: hashtagExternalId,
            type: 'hashtag',
            title: '#' + $scope.query
        });
    };

    function stripPrefix(value) {
        if(!value) return;

        // FIXME strip off all prefix, not just first char
        if((value[0] == '@' || value[0] == '#') && value.length > 1) {
            return value.substr(1);
        }
        return value;
    }



    function searchThings() {
        $scope.query = stripPrefix($scope.query);
        if(!$scope.query.length) return;

        if($scope.selectedType == 'hashtag') {
            return;
        }

        $location.search({
            query: $scope.query,
            type: $scope.selectedType
        });

        $scope.showNoResultsMessage = false;

        Thing.get('search', {type: $scope.selectedType, query: $scope.query})
            .then(function(things) {
                $scope.things = things;
                if(!$scope.things.length) {
                    $scope.showNoResultsMessage = true;
                }
            });
    }

    $scope.searchThings =  searchThings;
}]);