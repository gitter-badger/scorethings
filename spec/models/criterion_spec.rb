require 'rails_helper'

RSpec.describe Criterion do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "criterion validation" do
    it "the name is validated to be unique" do
      criterion = create(:positive_criterion)

      expect{
        create(:positive_criterion, {name: criterion.name})
      }.to raise_error(Mongoid::Errors::Validations)
    end
  end

  describe "criterion levels" do
    #TODO move into seperate criterion level spec?
    it "should get a level when there are all 10 levels" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(0, 'Absolutely Not Funny')
      criterion.add_level(1, 'Really Not Funny')
      criterion.add_level(2, 'Not Funny')
      criterion.add_level(3, 'Not Very Funny')
      criterion.add_level(4, 'Almost Funny')
      criterion.add_level(5, 'Sorta Funny')
      criterion.add_level(6, 'Pretty Funny')
      criterion.add_level(7, 'Funny')
      criterion.add_level(8, 'Hilarious')
      criterion.add_level(9, 'One Of The Funniest Things Ever')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(0)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(9)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(0)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(10)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Really Not Funny')

      level_for_points = criterion.find_level_for_points(58)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(5)
      expect(level_for_points.name).to eq('Sorta Funny')

      level_for_points = criterion.find_level_for_points(93)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(9)
      expect(level_for_points.name).to eq('One Of The Funniest Things Ever')
    end

    it "should get a level when there are only 3 levels" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(0, 'Absolutely Not Funny')
      criterion.add_level(1, 'Sorta Funny')
      criterion.add_level(2, 'Funny')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(0)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(9)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(0)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(10)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Sorta Funny')

      level_for_points = criterion.find_level_for_points(58)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Funny')

      level_for_points = criterion.find_level_for_points(93)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Funny')
    end
  end
end