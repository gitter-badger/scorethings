angular.module('app').service('shareText', ['pointsToLevel', function(pointsToLevel) {
    return {
        generateScoreTitle: function(thingTitle) {
            if(!thingTitle) return;
            return "Score for " + thingTitle;
        },
        generateScoreText: function(points, thingTitle, criterionName) {
            if(!thingTitle) return;

            var pointsLevel = pointsToLevel.translate(points);
            var text = "Score for " + thingTitle + ".  ";
            if(criterionName) {
                text += criterionName + "?  ";
            }
            text += pointsLevel + ".";
            return text;
        },
        generateNewScoreText: function(thingTitle, criterionName) {
            if(!thingTitle) return;

            var text = "How would you score " + thingTitle;
            if(criterionName) {
                text += " for " + criterionName;
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
