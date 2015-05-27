require 'spec_helper'

describe ContactMailer do
  describe "#contact" do
    let(:order_number) { 'R1234567890' }
    let(:contact)      { build :contact, site_version: 'site_version' }
    let(:mail)         { described_class.email(contact) }
    subject(:body)     { mail.body.encoded }

    it('upcases the site version') {
         is_expected.to include('SITE_VERSION')       }
    it { is_expected.to include(contact.subject)      }
    it { is_expected.to include(contact.first_name)   }
    it { is_expected.to include(contact.last_name)    }
    it { is_expected.to include(contact.message)      }
    it { is_expected.to include(contact.order_number) }
    it { is_expected.to include('Order Number:') }

    context 'order_number is optional' do
      let(:contact) { build :contact, order_number: nil }
      it { is_expected.to_not include('Order Number') }
    end
  end
end
