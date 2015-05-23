require 'rails_helper'

RSpec.describe Score do
  describe "delete if user is deleted" do
    it "should delete all scores that belonged to a user when the user is deleted" do
      user = create(:user_alpha)
      other_user = create(:user_bravo)

      expect(Score.all.length).to eq(0)
      user.create_score(build(:score))
      expect(Score.all.length).to eq(1)
      other_user.create_score(build(:score))
      expect(Score.all.length).to eq(2)

      expect(User.all.length).to eq(2)
      user.destroy!
      expect(User.all.length).to eq(1)
      expect(Score.all.length).to eq(1)
    end
  end
end