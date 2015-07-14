require 'spec_helper'


RSpec.describe ReturnRequestItem::ReturnRequestItemMapping do

  subject(:mapping) { described_class.new(return_request_item: return_request_item) }

  describe 'ignores keep items' do
    let(:return_request_item)  { instance_spy('ReturnRequestItem', action: 'keep') }

    it { expect(subject.call).to eq :no_action_required }
  end
end
