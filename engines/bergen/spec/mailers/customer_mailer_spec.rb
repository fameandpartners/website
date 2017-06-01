require 'spec_helper'

module Bergen
  RSpec.describe CustomerMailer, type: :mailer do

    describe 'default configurations' do
      let(:default_config) { described_class.default }

      it do
        expect(default_config[:from]).to eq('noreply@fameandpartners.com')
      end
    end

    describe '#received_parcel' do
      let(:item_return) { build(:item_return, order_number: 'R123123123', contact_email: 'loroteiro@silvestre.com') }
      let(:mailer) { described_class.received_parcel(item_return: item_return) }

      it do
        expect(mailer.subject).to eq('Fame and Partners Order R123123123 - Package Received')
        expect(mailer.to).to eq(['loroteiro@silvestre.com'])
        expect(mailer.body).to have_text('Thank you for sending back your order for return')
      end
    end
  end
end
