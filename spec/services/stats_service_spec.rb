require 'rails_helper'

RSpec.describe StatsService do
  before do
    @stats_service = StatsService.new
  end

  describe "stats service" do
    before do
      @user = create(:user)
      @thing = create(:thing)
      @other_thing = create(:thing)
      @criterion = create(:criterion)
      @other_criterion = create(:criterion)
      @other_user = create(:user)

      create(:score, thing: @thing, points: 4, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 9, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 7, criterion: @other_criterion, user: @user)
      create(:score, thing: @other_thing, points: 10, criterion: @criterion, user: @user)

      create(:score, thing: @other_thing, points: 2, criterion: @criterion, user: @other_user)
      create(:score, thing: @thing, points: 8, criterion: @criterion, user: @other_user)
    end

    it "should get stats for a thing" do
      stats = @stats_service.get_score_stats(thing: @thing)
      expect(stats.total).to eq(4)
      expect(stats.avg).to eq(7)
      expect(stats.min).to eq(4)
      expect(stats.max).to eq(9)
    end

    it "should get stats for a thing and a criterion" do
      stats = @stats_service.get_score_stats(thing: @thing, criterion: @criterion)
      expect(stats.total).to eq(3)
      expect(stats.avg).to eq(7)
      expect(stats.min).to eq(4)
      expect(stats.max).to eq(9)

      stats = @stats_service.get_score_stats(thing: @other_thing, criterion: @criterion)
      expect(stats.total).to eq(2)
      expect(stats.avg).to eq(6)
      expect(stats.min).to eq(2)
      expect(stats.max).to eq(10)

      stats = @stats_service.get_score_stats(thing: @thing, criterion: @other_criterion)
      expect(stats.total).to eq(1)
      expect(stats.avg).to eq(7)
      expect(stats.min).to eq(7)
      expect(stats.max).to eq(7)
    end

    it "should get score stats for a user" do
      stats = @stats_service.get_score_stats(user: @user)
      expect(stats.total).to eq(4)
      expect(stats.avg).to eq(7.5)
      expect(stats.min).to eq(4)
      expect(stats.max).to eq(10)
    end

    it "should get score stats for a user and a criterion" do
      stats = @stats_service.get_score_stats(user: @user, criterion: @criterion)
      expect(stats.total).to eq(3)
      expect(stats.avg).to be_within(0.1).of(7.667)
      expect(stats.min).to eq(4)
      expect(stats.max).to eq(10)
    end
  end
end
