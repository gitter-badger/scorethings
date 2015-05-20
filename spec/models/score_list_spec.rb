require 'rails_helper'

RSpec.describe ScoreList do
  before do
    @user = create(:user_alpha)
    @score_list = @user.create_score_list(name: 'My Thoughts On Cats')
  end

  describe "getting the average score" do
    it "should calculate the average score from multiple scores" do
      scores = []
      scores[0] = build(:score, points: 80)
      scores[1] = build(:score, points: 65)
      scores[2] = build(:score, points: 93)

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

  describe "creating a score list from a score" do
    before do
      @user = create(:user_alpha)
      @score = @user.create_score(build(:score))
    end

    it "should build a new score list from a score" do
      score_list = ScoreList.build_score_list_from_score(@score)
      expect(score_list).not_to be_nil
      expect(score_list.name).to eq("Score List For #{@score.thing.title}")
      expect(score_list.scores.length).to eq(1)
      expect(score_list.scores.first).to eq(@score)
      expect(score_list.things.length).to eq(1)
      expect(score_list.things.first.external_id).to_not be_nil
      expect(score_list.things.first.external_id).to eq(@score.thing.external_id)
      expect(score_list.things.first.type).to eq(@score.thing.type)
    end
  end

end