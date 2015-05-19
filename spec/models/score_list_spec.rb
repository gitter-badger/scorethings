require 'rails_helper'

RSpec.describe ScoreList do
  before do
    @user = create(:user_alpha)
    @score_list = @user.create_score_list(name: 'My Thoughts On Cats')
  end

  describe "getting the average score" do
    it "should calculate the average score from multiple scores" do
      scores = []
      scores << build(:score, points: 80)
      scores << build(:score, points: 65)
      scores << build(:score, points: 93)

      # avg = (80 + 65 + 93) / 3 = 79.3333 ~= 79
      scores.each do |score|
        @user.create_score(score)
        @score_list.scores << score
      end

      expect(@score_list.average_score).to eq(79)
      @score_list.scores << @user.create_score(build(:score, points: 88))
      # avg = (80 + 65 + 93 + 88) / 4 = 81.5 ~= 82
      expect(@score_list.average_score).to eq(82)
    end
  end

  describe "checking if a score list has scores that score list things matching a thing" do
    before do
      @score_list = build(:score_list)
      @thing = build(:hashtag_thing)
      @score_list_thing_that_matches_thing = ScoreListThing.build_from_thing(@thing)
      @score_list_thing_that_does_not_match_thing = ScoreListThing.build_from_thing(build(:hashtag_thing))
    end

    it "should return true if it has a score list thing that matches" do
      @score_list.score_list_things << @score_list_thing_that_does_not_match_thing
      expect(@score_list_thing_that_does_not_match_thing.matches_thing(@thing)).to be false
      expect(@score_list.has_score_list_thing_matching_thing(@thing)).to be false

      @score_list.score_list_things << @score_list_thing_that_matches_thing
      expect(@score_list.has_score_list_thing_matching_thing(@thing)).to be true
    end
  end

  describe "creating a score list from a score" do
    before do
      @user = create(:user_alpha)
      @score = @user.create_score(build(:score))
    end

    it "should build a new score list from a score" do
      score_list = ScoreList.build_score_list_from_score(@score)
      expect(score_list).not_to be_nil
      expect(score_list.name).to eq("Score List For #{@score.thing.display_value}")
      expect(score_list.scores.length).to eq(1)
      expect(score_list.scores.first).to eq(@score)
      expect(score_list.score_list_things.length).to eq(1)
      expect(score_list.score_list_things.first.external_id).to_not be_nil
      expect(score_list.score_list_things.first.external_id).to eq(@score.thing.external_id)
      expect(score_list.score_list_things.first.type).to eq(@score.thing.type)
    end
  end

end