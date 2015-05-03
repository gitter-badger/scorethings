require 'rails_helper'

RSpec.describe Score do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  describe "creating scores" do
    it "should calculate the total score of all subscores it has" do
      score = build(:twitter_handle_score)
      expect(score).to_not be_nil
      score.subscores << build(:positive_subscore, value: 40)
      score.subscores << build(:positive_subscore, value: 54)
      score.subscores << build(:negative_subscore, value: 30)

      # 40 + 54 + (-30) = 64
      expect(score.calculate_total_score).to eq(64)
    end

    it "should overwrite an existing subscore if adding a new one with the same criterion" do
      # in this case, a value for "Funny" already has been entered, adding "Funny" with a new value overwrites the old one
      # it does not result in 2 values for the same criterion
      score = build(:twitter_handle_score)
      positive_criterion = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.subscores.length).to eq(0)
      # add value once
      score.add_subscore(positive_criterion, 65)
      score.add_subscore(positive_criterion_2, 83)
      expect(score.subscores.length).to eq(2)
      expect(score.subscores.first.value).to eq(65)
      expect(score.subscores.second.value).to eq(83)

      expect(score.calculate_total_score).to eq(148)

      # add value again with same criterion
      score.add_subscore(positive_criterion, 52)
      expect(score.subscores.length).to eq(2) # not 3 values, still 2, first value is now the 52 just passed in
      expect(score.subscores.first.value).to eq(52)
      expect(score.subscores.second.value).to eq(83)
      expect(score.calculate_total_score).to eq(135)
    end
  end
end