require 'rails_helper'

RSpec.describe Criterion do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "criterion with criterion levels" do
    def check_criterion_level(criterion, level_number, name, floor, ceiling)
      criterion_levels_with_number = criterion.criterion_levels.where(level_number: level_number)
      expect(criterion_levels_with_number.length).to eq(1)
      criterion_level = criterion_levels_with_number.first
      expect(criterion_level.level_number).to eq(level_number)
      expect(criterion_level.name).to eq(name)
      expect(criterion_level.floor).to eq(floor)
      expect(criterion_level.ceiling).to eq(ceiling)
    end

    describe "getting a criterion level for a points value" do
      it "should add levels sequentialy without specifying the level number" do
        criterion = Criterion.new(name: 'Funny')
        criterion.add_level('Absolutely Not Funny') # adds first
        criterion.add_level('Really Not Funny') # second
        criterion.add_level('Not Funny') # third
        check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 33)
        check_criterion_level(criterion, 2, 'Really Not Funny', 34, 66)
        check_criterion_level(criterion, 3, 'Not Funny', 67, 100)
      end

      it "should get a level when there are all 10 levels" do
        criterion = Criterion.new(name: 'Funny')
        criterion.add_level('Absolutely Not Funny', 1)
        criterion.add_level('Really Not Funny', 2)
        criterion.add_level('Not Funny', 3)
        criterion.add_level('Not Very Funny', 4)
        criterion.add_level('Almost Funny', 5)
        criterion.add_level('Sorta Funny', 6)
        criterion.add_level('Pretty Funny', 7)
        criterion.add_level('Funny', 8)
        criterion.add_level('Hilarious', 9)
        criterion.add_level('One Of The Funniest Things Ever', 10)


        level_for_points = criterion.find_level_for_points(5)
        expect(level_for_points.level_number).to eq(1)


        level_for_points = criterion.find_level_for_points(9)
        expect(level_for_points.level_number).to eq(1)

        level_for_points = criterion.find_level_for_points(10)
        expect(level_for_points.level_number).to eq(1)

        level_for_points = criterion.find_level_for_points(11)
        expect(level_for_points.level_number).to eq(2)

        level_for_points = criterion.find_level_for_points(58)
        expect(level_for_points.level_number).to eq(6)

        level_for_points = criterion.find_level_for_points(93)
        expect(level_for_points.level_number).to eq(10)
      end

      describe "changing the criterion levels' level numbers, floors, and ceilings when levels are added and removed" do
        it "should re-determine criterion level floors and ceilings when a criterion level is removed" do
          criterion = Criterion.new(name: 'Funny')
          criterion.add_level('Absolutely Not Funny', 1)
          criterion.add_level('Sorta Funny', 2)
          criterion.add_level('Funny', 3)

          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 33)
          check_criterion_level(criterion, 2, 'Sorta Funny', 34, 66)
          check_criterion_level(criterion, 3, 'Funny', 67, 100)

          # removing level two just leaves 2 levels, 1-50, 51-100
          criterion.remove_level(2)
          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 50)
          check_criterion_level(criterion, 2, 'Funny', 51, 100)
        end

        it "should re-determine criterion level floors and ceilings when a criterion level is added at the end" do
          criterion = Criterion.new(name: 'Funny')
          criterion.add_level('Absolutely Not Funny', 1)
          criterion.add_level('Sorta Funny', 2)
          criterion.add_level('Funny', 3)

          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 33)
          check_criterion_level(criterion, 2, 'Sorta Funny', 34, 66)
          check_criterion_level(criterion, 3, 'Funny', 67, 100)

          # adding level at level 4 will cause there to be 4 levels
          criterion.add_level('Super Funny', 4)
          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 25)
          check_criterion_level(criterion, 2, 'Sorta Funny', 26, 50)
          check_criterion_level(criterion, 3, 'Funny', 51, 75)
          check_criterion_level(criterion, 4, 'Super Funny', 76, 100)
        end

        it "should re-determine criterion level floors and ceilings when a criterion level is added in the middle" do
          criterion = Criterion.new(name: 'Funny')
          criterion.add_level('Absolutely Not Funny', 1)
          criterion.add_level('Sorta Funny', 2)
          criterion.add_level('Funny', 3)

          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 33)
          check_criterion_level(criterion, 2, 'Sorta Funny', 34, 66)
          check_criterion_level(criterion, 3, 'Funny', 67, 100)

          # adding new criterion level at 2 will move the existing level 2, 3, 4 down 1
          criterion.add_level('Weird Funny', 2)
          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 25)
          check_criterion_level(criterion, 2, 'Weird Funny', 26, 50)
          check_criterion_level(criterion, 3, 'Sorta Funny', 51, 75)
          check_criterion_level(criterion, 4, 'Funny', 76, 100)
        end

        it "should re-determine criterion level floors and ceilings when a criterion level is added in the beginning" do
          criterion = Criterion.new(name: 'Funny')
          criterion.add_level('Absolutely Not Funny', 1)
          criterion.add_level('Sorta Funny', 2)
          criterion.add_level('Funny', 3)

          check_criterion_level(criterion, 1, 'Absolutely Not Funny', 1, 33)
          check_criterion_level(criterion, 2, 'Sorta Funny', 34, 66)
          check_criterion_level(criterion, 3, 'Funny', 67, 100)

          # adding new criterion level at 2 will move the existing level 2, 3, 4 down 1
          criterion.add_level('Movie 43 Territory', 1)
          check_criterion_level(criterion, 1, 'Movie 43 Territory', 1, 25)
          check_criterion_level(criterion, 2, 'Absolutely Not Funny', 26, 50)
          check_criterion_level(criterion, 3, 'Sorta Funny', 51, 75)
          check_criterion_level(criterion, 4, 'Funny', 76, 100)
        end

        it "should not allow more than 10 criterion levels to be added" do
          criterion = Criterion.new(name: 'Funny')
          (1..10).each do |n|
            criterion.add_level("Criterion Level #{n}")
          end

          expect{
            criterion.add_level("One too many")
          }.to raise_error(TooManyCriterionLevelsError)

        end
      end
    end
  end
end