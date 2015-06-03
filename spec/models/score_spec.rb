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

  describe "archiving score when points change" do
    before do
      @score = create(:score, user: @user, points: 75, meh_floor: 60, meh_ceiling: 85)
    end

    it "should archive the score" do
      expect(@score.points).to eq(75)
      expect(@score.score_archives.length).to eq(0)
      @score.update(points: 68)

      expect(@score.points).to eq(68)
      expect(@score.score_archives.length).to eq(1)
      expect(@score.score_archives.first.points).to eq(75)
      expect(@score.score_archives.first.meh_floor).to eq(60)
      expect(@score.score_archives.first.meh_ceiling).to eq(85)
    end

    it "should archive the score with new meh_floor and meh_ceiling" do
      expect(@score.points).to eq(75)
      @score.update(points: 68)
      expect(@score.score_archives.length).to eq(1)
      @score.update(meh_floor: 50, meh_ceiling: 70, points: 83)

      expect(@score.score_archives.length).to eq(2)

      expect(@score.points).to eq(83)
      expect(@score.meh_floor).to eq(50)
      expect(@score.meh_ceiling).to eq(70)

      expect(@score.score_archives.first.points).to eq(75)
      expect(@score.score_archives.first.meh_floor).to eq(60)
      expect(@score.score_archives.first.meh_ceiling).to eq(85)

      expect(@score.score_archives.last.points).to eq(68)
      expect(@score.score_archives.last.meh_floor).to eq(60)
      expect(@score.score_archives.last.meh_ceiling).to eq(85)
    end

    it "should not archive if updating invalid" do
      expect(@score.score_archives.length).to eq(0)
      expect {
        @score.update(points: 10000)
      }.to raise_error(Mongoid::Errors::Validations)

      expect(@score.score_archives.length).to eq(0)
    end
  end
end