angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'Thing', 'notifier', 'scoreModalFactory', function($scope, Thing, notifier, scoreModalFactory) {
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

    $scope.selectedThingType = 'twitter_account';

    $scope.$watch('selectedThingType', function() {
        $scope.things = [];
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

        /*
        console.log('scoring hashtag ' + hashtagExternalId);
        new ThingScore({
            externalId: hashtagExternalId,
            thingType: $scope.selectedThingType,
            score: {
                points: 75
            }
        }).create()
            .then(
            function(response) {
                var createdScore = response.score;
                notifier.success('created score for thing: ' + createdScore.thing.title);
            },
            function() {
                notifier.error('failed to created score');
            });
            */
    };

    function stripPrefix(value) {
        if(!value) return;

        // FIXME strip off all prefix, not just first char
        if((value[0] == '@' || value[0] == '#') && value.length > 1) {
            return value.substr(1);
        }
        return value;
    }


    $scope.searchThing = function() {
        $scope.query = stripPrefix($scope.query);
        if(!$scope.query.length) return;

        if($scope.selectedThingType == 'hashtag') {
            return;
        }

        Thing.get('search', {thingType: $scope.selectedThingType, query: $scope.query}).then(function(things) {
            $scope.things = things;
        });
    };
}]);