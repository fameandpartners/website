require 'spec_helper'

describe Forms::ManualOrderForm do
   context 'process' do
      let(:false_params) {
        {
          currency: 'USD',
          style_name: '794',
          size: '24',
          length: 'standart',
          color: '179',
          customisations: '1873',
          notes: 'notes',
          status: 'exchange',
          existing_customer: '14'
        }
      }

      let(:correct_params) {
        {
          currency: 'USD',
          style_name: '681',
          size: '149',
          length: 'standart',
          color: '25',
          customisations: '1599',
          notes: 'notes',
          status: 'exchange',
          email: 'john.doe@gmail.com',
          first_name: 'John',
          last_name: 'Doe',
          address1: 'Address1',
          address2: 'Address2',
          city: 'Los-Angeles',
          country: '49',
          state: '32',
          zipcode: '61201',
          phone: '+380977789031'
        }
      }

    it 'creates new false order' do
      manual_order = described_class.new(Spree::Order.new)
      expect { manual_order.save_order(false_params) }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'creates new false order' do
       manual_order = described_class.new(Spree::Order.new)
       expect(manual_order.save_order(correct_params)).to true
    end

  end
end
