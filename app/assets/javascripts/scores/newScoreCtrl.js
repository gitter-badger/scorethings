angular.module('app').controller('NewScoreCtrl', ['$scope', '$location', 'Score', 'usSpinnerService', 'twitter', 'notifier', function($scope, $location, Score, usSpinnerService, twitter, notifier) {
    $scope.handleThingInputValue = function(thingInputValue) {
        if(!thingInputValue || thingInputValue < 1) {
            return notifier.error('could not create score, thing input is not known');
        }
        if(thingInputValue.substring(0, 1) == '@') {
            var twitterHandle = thingInputValue.substring(1, thingInputValue.length);
            usSpinnerService.spin('spinner-1');
            return twitter.searchTwitterHandles(twitterHandle,
                successfulTwitterHandleSearch,
                function error(errors) {
                    usSpinnerService.stop('spinner-1');
                    return notifier.error(errors);
                });
        } else if(thingInputValue.substring(0, 1) == '#') {
            var twitterHashtag = thingInputValue.substring(1, thingInputValue.length);
            return createScore('TWITTER_HASHTAG', twitterHashtag, 'created score for twitter hashtag #' + twitterHashtag);
        }
    };

    function createScore(type, value, successMsg) {
        usSpinnerService.spin('spinner-1');
        Score.post({
            score: {
                thing: {
                    type: type,
                    value: value
                }
            }
        }).then(
            function (response) {
                usSpinnerService.stop('spinner-1');
                console.log(response);
                var score = response.score;
                if (!score || !score._id) {
                    return notifier.error('could not go to see created score');
                } else {
                    $location.path('/scores/' + score.id)
                }
            })
    };

    function successfulTwitterHandleSearch(response) {
        usSpinnerService.stop('spinner-1');
        var results = response.results;
        if(!results || results.length == 0) {
            // no twitter handles found
            return notifier.error('Could not find twitter account');
        } else if(results.length > 1) {
            // more than 1 twitter handles found
            // show the search results for user to choose from
            return $scope.twitterUsers = results;
        } else {
            // only 1 twitter handle found
            // use that to create the score
            var singleTwitterUserResult = results[0];
            var uidForOnlySearchResult = singleTwitterUserResult.id;
            if(!uidForOnlySearchResult) {
                return notifier.error('Problem finding twitter user id in search response');
            }
            return createScore('TWITTER_UID', uidForOnlySearchResult, twitterAccountScoreSuccess(singleTwitterUserResult));
        }
    }

    $scope.selectTwitterUserToCreateScore = function(twitterUser) {
        if(!twitterUser || !twitterUser.id) {
            return notifier.error('error selecting twitter user to create score from');
        }

        return createScore('TWITTER_UID', twitterUser.id, twitterAccountScoreSuccess(twitterUser));
    };

    function twitterAccountScoreSuccess(twitterUser) {
       return 'Created score for twitter user @' + twitterUser.screen_name;
    }

}]);