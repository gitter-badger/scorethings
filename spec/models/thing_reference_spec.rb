require 'rails_helper'

RSpec.describe ThingReference do
  before do
    @user = create(:user)
  end

  describe "finding hashtag thing reference by external_id" do
    it "should find any with external_id" do
      @thing_a = create(:thing_reference, :hashtag, external_id: 'ApplePie')
      @thing_b = create(:thing_reference, :hashtag, external_id: 'BananaCake')
      @thing_c = create(:thing_reference, :hashtag, external_id: 'CherriePie')

      things = ThingReference.find_hashtag_thing_by_external_id('Pie')
      expect(things).to_not be_nil
      expect(things.length).to eq(2)
      expect(things.first.external_id).to eq('ApplePie')
      expect(things.first.title).to eq('#ApplePie')
      expect(things.first.type).to eq(Scorethings::ThingTypes::HASHTAG)
      expect(things.last.external_id).to eq('CherriePie')
      expect(things.last.title).to eq('#CherriePie')
    end
  end
end