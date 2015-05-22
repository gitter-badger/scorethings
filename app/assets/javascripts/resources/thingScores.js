angular.module('app').factory('ThingScore', ['railsResourceFactory', 'railsSerializer', function(railsResourceFactory, railsSerializer) {
    // copied from https://github.com/FineLinePrototyping/angularjs-rails-resource/issues/32#issuecomment-55658356
    var thingScore = railsResourceFactory({
        name: 'score',
        url: '/api/v1/things/{{thing_type}}/{{external_id}}',
        rootWrapping: false,
        serializer: railsSerializer(function() {
            this.exclude('thingType', 'externalId');
        })
    });

    thingScore.prototype.create =  function() {
        return this.$post(this.constructor.resourceUrl({ thing_type: this.thingType, external_id: this.externalId }, '/scores'));
    };

    return thingScore;
}]);
