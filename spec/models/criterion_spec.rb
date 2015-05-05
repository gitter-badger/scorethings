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
    # FIXME hard to understand specs
    # may hide bugs
    # rather than use find_level_for_points to test,
    # check criterion_level floor/ceiling/level_number
    it "should get a level when there are all 10 levels" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(1, 'Absolutely Not Funny')
      criterion.add_level(2, 'Really Not Funny')
      criterion.add_level(3, 'Not Funny')
      criterion.add_level(4, 'Not Very Funny')
      criterion.add_level(5, 'Almost Funny')
      criterion.add_level(6, 'Sorta Funny')
      criterion.add_level(7, 'Pretty Funny')
      criterion.add_level(8, 'Funny')
      criterion.add_level(9, 'Hilarious')
      criterion.add_level(10, 'One Of The Funniest Things Ever')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(9)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(10)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(11)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Really Not Funny')

      level_for_points = criterion.find_level_for_points(58)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(6)
      expect(level_for_points.name).to eq('Sorta Funny')

      level_for_points = criterion.find_level_for_points(93)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(10)
      expect(level_for_points.name).to eq('One Of The Funniest Things Ever')
    end

    it "should get a level when there are only 3 levels" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(1, 'Absolutely Not Funny')
      criterion.add_level(2, 'Sorta Funny')
      criterion.add_level(3, 'Funny')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(33)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(34)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Sorta Funny')

      level_for_points = criterion.find_level_for_points(66)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Sorta Funny')

      level_for_points = criterion.find_level_for_points(67)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(3)
      expect(level_for_points.name).to eq('Funny')

      level_for_points = criterion.find_level_for_points(100)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(3)
      expect(level_for_points.name).to eq('Funny')
    end

    it "should re-determine criterion level floors and ceilings when a criterion level is removed" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(1, 'Absolutely Not Funny')
      criterion.add_level(2, 'Sorta Funny')
      criterion.add_level(3, 'Funny')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(33)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(34)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Sorta Funny')

      # removing level two just leaves 2 levels, 1-50, 51-100
      criterion.remove_level(2)
      level_for_points = criterion.find_level_for_points(34)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')
    end

    it "should re-determine criterion level floors and ceilings when a criterion level is added" do
      criterion = Criterion.new(name: 'Funny')
      criterion.add_level(1, 'Absolutely Not Funny')
      criterion.add_level(2, 'Sorta Funny')
      criterion.add_level(3, 'Funny')

      level_for_points = criterion.find_level_for_points(5)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')


      level_for_points = criterion.find_level_for_points(33)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')

      level_for_points = criterion.find_level_for_points(34)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(2)
      expect(level_for_points.name).to eq('Sorta Funny')

      # removing level two just leaves 2 levels, 1-50, 51-100
      criterion.remove_level(2)
      level_for_points = criterion.find_level_for_points(34)
      expect(level_for_points).to_not be_nil
      expect(level_for_points.level_number).to eq(1)
      expect(level_for_points.name).to eq('Absolutely Not Funny')
    end
  end
end