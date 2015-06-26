require 'rails_helper'

RSpec.describe Score do
  before do
    @user = create(:user)
  end

  describe "delete if user is deleted" do
    it "should delete all scores that belonged to a user when the user is deleted" do
      other_user = create(:user)

      expect(Score.all.length).to eq(0)
      @user.create_score(build(:score))
      expect(Score.all.length).to eq(1)
      other_user.create_score(build(:score))
      expect(Score.all.length).to eq(2)

      expect(User.all.length).to eq(2)
      @user.destroy!
      expect(User.all.length).to eq(1)
      expect(Score.all.length).to eq(1)
    end
  end

  describe "updating points" do
    it "should update the points and put into old points" do
      score = create(:score, points: 7, user: @user)

      expect(score.points).to eq(7)
      expect(score.old_points.length).to eq(0)

      score.update_points(8)
      score.update_points(6)

      # TODO write specs for old_points started_at/ended_at dates

      expect(score.points).to eq(6)
      expect(score.old_points.length).to eq(2)
      expect(score.old_points.first.points).to eq(7)
      expect(score.old_points.second.points).to eq(8)
    end
  end
end