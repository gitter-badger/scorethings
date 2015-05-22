angular.module('app').controller('ThingsSearchCtrl', ['$scope', 'Thing', 'ThingScore', 'notifier', function($scope, Thing, ThingScore, notifier) {
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
        $scope.query = '';
    });


    $scope.scoreThing = function(thing) {
        console.log(thing);
        new ThingScore({
            externalId: thing.externalId,
            thingType: $scope.selectedThingType,
            score: {
                points: 75
            }
        }).create()
            .then(
                function(response) {
                    var createdScore = response.score;
                    notifier.success('created score for thing: ' + createdScore.thing.title);
                    console.log(createdScore);
                },
                function() {
                    notifier.error('failed to created score');
                });
    };
    $scope.scoreHashtagQuery = function() {
        var hashtagExternalId = stripPrefix($scope.query);
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
                console.log(createdScore);
            },
            function() {
                notifier.error('failed to created score');
            });
    };

    function stripPrefix(value) {
        if(!value) return;

        if((value[0] == '@' || value[0] == '#') && value.length > 1) {
            return value.substr(1);
        }
        return value;
    }


    $scope.findThing = function() {
        $scope.query = stripPrefix($scope.query);
        if(!$scope.query.length) return;

        if($scope.selectedThingType == 'hashtag') {
            return $scope.scoreHashtagQuery();
        }

        Thing.get('search', {thingType: $scope.selectedThingType, query: $scope.query}).then(function(things) {
            $scope.things = things;
        });
    };
}]);