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
end