require 'rails_helper'

RSpec.describe User do
  it "does something" do
    manu = build(:manu)

    expect(manu.twitterHandle).to eq('manuisfunny')
    expect(manu.say_hello).to eq('hello twitter user @manuisfunny')
  end
end