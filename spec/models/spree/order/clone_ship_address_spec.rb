require 'spec_helper'

describe Spree::Order::CloneShipAddress, type: :model do
  subject(:order) { Spree::Order.new }

  it { is_expected.to allow_mass_assignment_of(:use_shipping) }

  describe '#use_shipping?' do
    it 'returns true for truthy values' do
      truthy_values = [true, 'true', '1']
      truthy_values.each do |value|
        order.use_shipping = value
        expect(order.use_shipping?).to eq(true)
      end
    end

    it 'returns false for falsey values' do
      falsey_values = [nil, false]
      falsey_values.each do |value|
        order.use_shipping = value
        expect(order.use_shipping?).to eq(false)
      end
    end
  end

  describe '#clone_shipping_address' do
    let(:address) { Spree::Address.new({ id:         123,
                                         address1:   'Rua da Silva Sauro',
                                         city:       'Lugar Nenhum',
                                         email:      'super@email.com',
                                         firstname:  'Loroteiro',
                                         lastname:   'Silvestre',
                                         phone:      '1234-1234',
                                         zipcode:    '1234-567',
                                         updated_at: '10/10/10',
                                         created_at: '10/10/10',
                                       }, without_protection: true)
    }

    before(:each) { order.ship_address = address }

    context 'when using shipping address' do
      before(:each) { order.use_shipping = true }

      it 'copies all ship address attributes to the bill address' do
        order.valid?

        bill_address_attributes = order.bill_address.attributes
        expect(bill_address_attributes).to include({ 'address1'  => 'Rua da Silva Sauro',
                                                     'city'      => 'Lugar Nenhum',
                                                     'email'     => 'super@email.com',
                                                     'firstname' => 'Loroteiro',
                                                     'lastname'  => 'Silvestre',
                                                     'phone'     => '1234-1234',
                                                     'zipcode'   => '1234-567' })
        expect(bill_address_attributes.keys).not_to include(%w(id updated_at created_at))
      end
    end

    context 'when not using shipping address' do
      before(:each) { order.use_shipping = false }

      it 'keeps bill address as it is' do
        expect(order.bill_address).to be_nil
      end
    end
  end
end
