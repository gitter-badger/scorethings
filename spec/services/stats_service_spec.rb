require 'rails_helper'

RSpec.describe StatsService do
  before do
    @stats_service = StatsService.new
  end

  describe "thing stats service" do
    it "should get stats for a thing" do
      user = create(:user)
      thing = create(:thing)
      other_thing = create(:thing)
      criterion = create(:criterion)
      other_criterion = create(:criterion)

      create(:score, thing: thing, points: 4, criterion: criterion, user: user)
      create(:score, thing: thing, points: 9, criterion: criterion, user: user)
      create(:score, thing: thing, points: 7, criterion: other_criterion, user: user)
      create(:score, thing: other_thing, points: 10, criterion: criterion, user: user)

      expect(@stats_service.thing_stats_by_criterion(thing._id, criterion).total).to eq(2)
      expect(@stats_service.thing_stats_by_criterion(thing._id, criterion).avg).to eq(6.5)
      expect(@stats_service.thing_stats_by_criterion(thing._id, criterion).min).to eq(4)
      expect(@stats_service.thing_stats_by_criterion(thing._id, criterion).max).to eq(9)

      expect(@stats_service.thing_stats_by_criterion(other_thing._id, criterion).total).to eq(1)
      expect(@stats_service.thing_stats_by_criterion(other_thing._id, criterion).avg).to eq(10)
      expect(@stats_service.thing_stats_by_criterion(other_thing._id, criterion).min).to eq(10)
      expect(@stats_service.thing_stats_by_criterion(other_thing._id, criterion).max).to eq(10)

      expect(@stats_service.thing_stats_by_criterion(thing._id, other_criterion).total).to eq(1)
      expect(@stats_service.thing_stats_by_criterion(thing._id, other_criterion).avg).to eq(7)
      expect(@stats_service.thing_stats_by_criterion(thing._id, other_criterion).min).to eq(7)
      expect(@stats_service.thing_stats_by_criterion(thing._id, other_criterion).max).to eq(7)

      expect(@stats_service.thing_stats(thing._id).total).to eq(3)
      expect(@stats_service.thing_stats(thing._id).avg).to be_within(0.1).of(6.66)
      expect(@stats_service.thing_stats(thing._id).min).to eq(4)
      expect(@stats_service.thing_stats(thing._id).max).to eq(9)
    end
  end
end
