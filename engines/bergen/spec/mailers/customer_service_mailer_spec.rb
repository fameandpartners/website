require 'spec_helper'

require_relative '../support/return_item_ready_to_process_context'

module Bergen
  RSpec.describe CustomerServiceMailer, type: :mailer do

    describe 'default configurations' do
      let(:default_config) { described_class.default }

      it do
        expect(default_config[:to]).to eq(%w(team@fameandpartners.com returns@fameandpartners.com))
        expect(default_config[:from]).to eq('bergen-3pl@fameandpartners.com')
      end
    end

    shared_examples 'CustomerServiceMailer body' do
      include_context 'return item ready to process'

      def assert_body
        encoded_mailer = mailer.body.encoded

        expect(encoded_mailer).to have_text('Order Number R123123')
        expect(encoded_mailer).to have_text('Order Date 2015-10-10 05:34:00 -0700')
        expect(encoded_mailer).to have_text('Bergen ASN Number WHRTN1044588')
        expect(encoded_mailer).to have_text('Product Name Stylight')
        expect(encoded_mailer).to have_text('Style Number product-sku')
        expect(encoded_mailer).to have_text('Product UPC (Global SKU ID) 10001')
        expect(encoded_mailer).to have_text('Size US10/AU14')
        expect(encoded_mailer).to have_text('Color Blue')
        expect(encoded_mailer).to have_text('Height petite')
        expect(encoded_mailer).to have_text('Customization Super Custom')
        expect(encoded_mailer).to have_text('Item Purchase Price $123.45')
        expect(encoded_mailer).to have_text('Customer Address 1226 Factory Place, Los Angeles, California, 90013, United States of America')
      end
    end

    describe '#accepted_parcel' do
      subject(:mailer) { described_class.accepted_parcel(item_return: item_return) }

      include_examples 'CustomerServiceMailer body'

      it do
        expect(mailer.subject).to eq('[Bergen] ACCEPTED - Order R123123 received')
        assert_body
      end
    end

    describe '#rejected_parcel' do
      subject(:mailer) { described_class.rejected_parcel(item_return: item_return) }

      include_examples 'CustomerServiceMailer body'

      it do
        expect(mailer.subject).to eq('[Bergen] REJECTED - Order R123123 received')
        assert_body
      end
    end
  end
end
