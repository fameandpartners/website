require 'rails_helper'

RSpec.describe FabricCard, :type => :model do
  it { is_expected.to validate_presence_of :name }
end
