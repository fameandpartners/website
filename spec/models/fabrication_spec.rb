require 'spec_helper'

RSpec.describe Fabrication, :type => :model do
  it do
    expect(described_class.new).to validate_presence_of :line_item_id
  end
end
