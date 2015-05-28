angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'Thing', 'notifier', 'scoreModalFactory', '$stateParams', '$location', function($scope, Thing, notifier, scoreModalFactory, $stateParams, $location) {
    $scope.showNoResultsMessage = false;
    handleQueryParams($location.$$search);

    function handleQueryParams(params) {
        if(!params) return;

        $scope.query = params.query;
        $scope.selectedThingType = params.thingType || 'twitter_account';
        if(params.query && params.thingType) {
            searchThing();
        }
    }

    function validThingType(label, examplePlaceholder) {
        return {
            label: label,
            examplePlaceholder: examplePlaceholder && ('Example: ' + examplePlaceholder)
        };
    }
    $scope.validThingTypes = {
        twitter_account: validThingType('Twitter Account', 'Patton Oswalt, @pattonoswalt, pattonoswalt, or https://twitter.com/pattonoswalt'),
        twitter_tweet: validThingType('Twitter Tweet', 'I like cats or https://twitter.com/manuisfunny/status/599219499766718'),
        youtube_video: validThingType('YouTube Video', 'Cat Stuff or https://www.youtube.com/watch?v=B66feInucFY'),
        hashtag: validThingType('Hashtag', '#SomethingCats or SomethingCats')
    };


    $scope.$watch('selectedThingType', function() {
        $scope.things = [];
        $scope.showNoResultsMessage = false;
    });

    $scope.$watch('query', function() {
        $scope.showNoResultsMessage = false;
    });


    $scope.scoreThing = function(thing) {
        console.log(thing);
        var scoreInput = {thing: thing};
        scoreModalFactory.openModal(scoreInput, {closeOnSave: false}, function saveSuccessCallbackFn(response) {
            console.log('in thing search');
            console.log(response);
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


    $scope.searchThing =  searchThing;

    function searchThing() {
        $scope.query = stripPrefix($scope.query);
        if(!$scope.query.length) return;

        if($scope.selectedThingType == 'hashtag') {
            return;
        }

        $location.search({
            query: $scope.query,
            thingType: $scope.selectedThingType
        });

        $scope.showNoResultsMessage = false;

        Thing.get('search', {thingType: $scope.selectedThingType, query: $scope.query}).then(function(things) {
            $scope.things = things;
            if(!$scope.things.length) {
                $scope.showNoResultsMessage = true;
            }
        });
    }
}]);