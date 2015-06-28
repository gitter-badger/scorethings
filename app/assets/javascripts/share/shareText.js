angular.module('app').service('shareText', ['pointsToLevel', function(pointsToLevel) {
    return {
        generateCreatedScoreTitle: function(score) {
            if(!score) return;
            return "Score for " + score.scoredThing.title;
        },
        generateCreatedScoreText: function(score) {
            if(!score) return;

            var pointsLevel = pointsToLevel.translate(score.points);
            var text = "Score for " + score.scoredThing.title + ".  ";
            if(score.criterion) {
                text += score.criterion.name + "?  ";
            }
            text += pointsLevel + ".";
            return text;
        },
        generateNewScoreText: function(thingTitle, criterionName) {
            if(!thingTitle) return;

            var text = "How would you score " + thingTitle;
            if(criterionName) {
                text += " on " + criterionName;
            }
            text += "?";
            return text;
        },
        generateNewScoreTitle: function(thingTitle, criterionName) {
            if(!thingTitle) return;

            if(criterionName) {
                return "Is " + thingTitle + " " + criterionName + "?";
            } else {
                return thingTitle + ": No, Meh, or Yes?";
            }
        }
    }

}]);
