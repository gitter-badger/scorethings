require 'rails_helper'

RSpec.describe Score do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  describe "creating scores" do
    it "should calculate the total score of all score criteria values it has" do
      score = build(:twitter_handle_score)
      expect(score).to_not be_nil
      score.score_criterion_values << build(:positive_score_criterion_value, value: 40)
      score.score_criterion_values << build(:positive_score_criterion_value, value: 54)
      score.score_criterion_values << build(:negative_score_criterion_value, value: 30)

      # 40 + 54 + (-30) = 64
      expect(score.calculate_total_score).to eq(64)
    end

    it "should overwrite an existing score criterion value if adding a new one with the same criterion" do
      # in this case, a value for "Funny" already has been entered, adding "Funny" with a new value overwrites the old one
      # it does not result in 2 values for the same criterion
      score = build(:twitter_handle_score)
      positive_criterion = create(:positive_criterion)

      expect(score.score_criterion_values.length).to eq(0)
      # add value once
      score.add_score_criterion_value(positive_criterion, 65)
      expect(score.score_criterion_values.length).to eq(1)
      expect(score.score_criterion_values.first.value).to eq(65)

      # add value again with same criterion
      score.add_score_criterion_value(positive_criterion, 52)
      expect(score.score_criterion_values.length).to eq(1) # not 2 values, still 1, value is now the 52 just passed in
      expect(score.score_criterion_values.first.value).to eq(52)
    end
  end
end