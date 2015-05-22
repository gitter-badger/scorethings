require 'rails_helper'

RSpec.describe ScoreCategory do
  describe "generating a map" do
    before do
      @score_categories = create_list(:score_category, 2)
      @general_score_category = create(:score_category, general: true)
      @score_categories <<  @general_score_category
    end

    it "should generate a map with the score categories as keys, and the general score category" do
      score_categories_map = ScoreCategory.generate_score_categories_map
      expect(score_categories_map).to_not be_nil
      expect(score_categories_map[@score_categories.first._id.to_s]).to_not be_nil
      expect(score_categories_map[@score_categories.first._id.to_s]).to eq(@score_categories.first)
      expect(score_categories_map[@score_categories.second._id.to_s]).to_not be_nil
      expect(score_categories_map[@score_categories.second._id.to_s]).to eq(@score_categories.second)
      expect(score_categories_map[:general]).to eq(@general_score_category)
    end
  end
end