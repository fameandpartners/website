require 'rails_helper'

RSpec.describe MoodboardItemEvent, :type => :model do

  describe '#creation' do
    subject(:event) { MoodboardItemEvent.creation.new }

    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :product_id }
    it { is_expected.to validate_presence_of :color_id }
  end
end
