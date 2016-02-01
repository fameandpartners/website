require 'spec_helper'

RSpec.describe FeatureFlag, :type => :model do
  it do
    FeatureFlag.set :foo, "bar"

    expect(FeatureFlag.get(:foo)).to eq "bar"
  end

  it do
    FeatureFlag.set :foo, "bar"
    FeatureFlag.set :foo, "baz"

    expect(FeatureFlag.get(:foo)).to eq "baz"
  end
end
