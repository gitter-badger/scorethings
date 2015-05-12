require 'rails_helper'

RSpec.describe Score do
  describe "calculate points from score categories" do
    it "should calculate the points using the average of all subscores it has" do
      score = Score.create(thing: build(:twitter_uid_thing))
      score.add_score_category(build(:score_category, points: 40))
      score.add_score_category(build(:score_category, points: 54))
      score.add_score_category(build(:score_category, points: 30))

      # (40 + 54 + 30) / 3 = 41.3333 = 41
      expect(score.score_categories.length).to eq(3)
      expect(score.points).to eq(41)
    end

    it "should calculate the rounded average" do
      score = Score.create(thing: build(:twitter_uid_thing))
      score.add_score_category(build(:score_category, points: 40))
      score.add_score_category(build(:score_category, points: 57))

      # (40 + 54 + 30) / 3 = 48.5 -> 49
      expect(score.points).to eq(49)
    end

   it "should change the score points, deleting all previous score categories" do
      score = Score.create(thing: build(:twitter_uid_thing))
      score.add_score_category(build(:score_category, points: 40))
      score.add_score_category(build(:score_category, points: 54))
      score.add_score_category(build(:score_category, points: 30))

      # (40 + 54 + 30) / 3 = 41.3333 = 41
      expect(score.score_categories.length).to eq(3)
      expect(score.points).to eq(41)
      expect(score.valid?).to be true

      # points = 45, no more score categories, just use points
      score.change_points(45)
      expect(score.score_categories.length).to eq(0)
      expect(score.points).to eq(45)
   end
  end

  describe "restrict adding score categories" do
    it "should not allow redundant score categories, two with same category" do
      score = Score.create(thing: build(:twitter_uid_thing))
      category = create(:category)
      other_category = create(:category)

      score.add_score_category(build(:score_category, points: 21, category: category))
      expect(score.score_categories.length).to eq(1)

      expect {
        score.add_score_category(build(:score_category, points: 40, category: category))
      }.to raise_error(ScoreCategoryRedundancyError)
      expect(score.score_categories.length).to eq(1)

      score.add_score_category(build(:score_category, points: 40, category: other_category))
      expect(score.score_categories.length).to eq(2)
    end
  end

  describe "validates points" do
    it "should only allow points between 1 and 100" do
      score = Score.create(thing: build(:twitter_uid_thing))
      score.change_points(45)
      expect(score.valid?).to be true
      score.change_points(101)
      expect(score.valid?).to be false
    end
  end
end