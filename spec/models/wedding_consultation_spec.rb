require 'rails_helper'

RSpec.describe WeddingConsultation, :type => :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :contact_method }
  end
end
