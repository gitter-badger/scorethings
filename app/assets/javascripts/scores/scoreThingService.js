angular.module('app').service('ScoreThingService', ['Score', 'Thing', function(Score, Thing) {
    function createOrUpdateScoreWithExistingThing(score, successCallbackFn, errorCallbackFn) {
        if(score.id) {
            new Score(score).update().then(
                function updateScoreSucces(score) {
                    return successCallbackFn(score);
                },
                function updateScoreError() {
                    return errorCallbackFn('failed to update score');
                }
            )
        } else {
            new Score(score).create().then(
                function createScoreSucces(score) {
                    return successCallbackFn(score);
                },
                function createScoreError() {
                    return errorCallbackFn('failed to create score');
                }
            )
        }
    }

    return {
        createOrUpdateScore: function(score, successCallbackFn, errorCallbackFn) {
            if(score.thing && score.thing.id) {
                score.thingId = score.thing.id;
                delete score.thing;
            }

            if(score.thingId) {
                return createOrUpdateScoreWithExistingThing(score, successCallbackFn, errorCallbackFn);
            } else {
                var thingParams = {
                    externalId: score.thing.externalId,
                    type: score.thing.type
                };
                if(score.thing != null) {
                    Thing.query(thingParams).then(function(things) {
                            if(things.length == 1) {
                                score.thing = things[0];
                                return createOrUpdateScoreWithExistingThing(score, successCallbackFn, errorCallbackFn);
                            } else if(things.length > 1) {
                                console.error('the combination of thing externalId and type should be unique, but more than one thing were retrieved');
                                console.error('using the query params: ', thingParams);
                                console.error('things: ', things);
                                return errorCallbackFn('found more then one thing existing when creating score, this should not happen');
                            } else {
                                new Thing(thingParams).create().then(
                                    function successThingCreate(thing) {
                                        score.thing = thing;
                                        return createOrUpdateScoreWithExistingThing(score, successCallbackFn, errorCallbackFn);
                                    },
                                    function errorThingCreate(){
                                        return errorCallbackFn('failed to create thing to be scored');
                                    });
                            }
                        })

                }

            }

        }

    };
}]);