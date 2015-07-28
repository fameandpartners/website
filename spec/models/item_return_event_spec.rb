require 'rails_helper'

RSpec.describe ItemReturnEvent, :type => :model do

  describe 'creation' do
    subject(:event) { ItemReturnEvent.creation.new }

    it { is_expected.to validate_presence_of :line_item_id }
  end

  xdescribe 'return_requested'

  describe 'receive_item' do
    subject(:event) { ItemReturnEvent.receive_item.new }

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :location }
    it { is_expected.to validate_inclusion_of(:location).in_array(%w[AU US]) }
    it { is_expected.to validate_presence_of :received_on }
  end

  describe 'approve' do
    subject(:event) { ItemReturnEvent.approve.new }

    it { is_expected.to validate_presence_of :user }
  end
end
