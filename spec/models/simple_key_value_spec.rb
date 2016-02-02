require 'spec_helper'

RSpec.describe SimpleKeyValue, :type => :model do
  it do
    SimpleKeyValue.set :foo, "bar"

    expect(SimpleKeyValue.get(:foo)).to eq "bar"
  end

  it do
    SimpleKeyValue.set :foo, "bar"
    SimpleKeyValue.set :foo, "baz"

    expect(SimpleKeyValue.get(:foo)).to eq "baz"
  end
end
