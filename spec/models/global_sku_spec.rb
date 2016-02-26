require 'rails_helper'

RSpec.describe GlobalSku, :type => :model do

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of :sku }
  end
end
