require "test_helper"

describe ScoreCriterion do
  let(:score_criterion) { ScoreCriterion.new }

  it "must be valid" do
    score_criterion.must_be :valid?
  end
end
