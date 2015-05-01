require "test_helper"

describe Subject do
  let(:subject) { Subject.new }

  it "must be valid" do
    subject.must_be :valid?
  end
end
