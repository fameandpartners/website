require 'rails_helper'

RSpec.describe FabricCardColour, :type => :model do
  it { is_expected.to validate_presence_of :position }
end
