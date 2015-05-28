angular.module('app').factory('ScoreListScore', ['railsResourceFactory', 'railsSerializer', function(railsResourceFactory, railsSerializer) {
    var scoreListScore = railsResourceFactory({
        name: 'score',
        url: '/api/v1/score_lists/{{score_list_id}}/scores/{{score_id}}',
        rootWrapping: false,
        serializer: railsSerializer(function() {
            this.exclude('scoreListId', 'scoreId');
        })
    });

    scoreListScore.prototype.add =  function() {
        return this.$post(this.constructor.resourceUrl({ score_list_id: this.scoreListId, score_id: this.scoreId }));
    };

    scoreListScore.prototype.remove =  function() {
        return this.$delete(this.constructor.resourceUrl({ score_list_id: this.scoreListId, score_id: this.scoreId }));
    };

    return scoreListScore;
}]);
