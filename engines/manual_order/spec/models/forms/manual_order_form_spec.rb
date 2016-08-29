require 'spec_helper'
require_relative '../../support/manual_orders_shared_context'

describe Forms::ManualOrderForm do

  context 'process' do
    include_context 'manual order context'

    let(:false_params){
      {
        currency: 'USD',
        style_name: '794',
        size: '24',
        height: 'standard',
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
        style_name: product.id,
        size: dress_size.id,
        height: 'petite',
        color: dress_color.id,
        adj_amount: '-10',
        adj_description: 'PROMO',
        notes: 'notes',
        status: 'exchange',
        email: 'john.doe@gmail.com',
        first_name: 'John',
        last_name: 'Doe',
        address1: 'Address1',
        address2: 'Address2',
        city: 'Los-Angeles',
        country: country.id,
        state: state.id,
        zipcode: '61201',
        phone: '+38094659031'
      }
    }

    let(:manual_order) { described_class.new(Spree::Order.new) }

    describe 'creates falsey order' do
      it { expect { manual_order.save_order(false_params) }.to raise_error ActiveRecord::RecordNotFound }

      it 'creates new order without customer (no state)' do
        new_order = manual_order.save_order(correct_params.merge(state: ''))
        expect(new_order.user).to be_nil
      end
    end

    describe 'creates truthy order' do

      let(:created_order) { manual_order.save_order(correct_params) }

      it 'creates new order successfully' do
        expect(created_order).to be_truthy
        expect(created_order.user).to be_truthy
        expect(created_order.site_version).to eq('us')
        expect(created_order.currency).to eq('USD')
        expect(created_order.number[0]).to eq('E')
        expect(created_order.state).to eq('complete')
        expect(created_order.completed_at).to be_truthy
        expect(created_order.line_items.first.personalization.height).to eq('petite')
        expect(created_order.projected_delivery_date).to be_truthy
        expect(created_order.completed_at).to be_an_instance_of(ActiveSupport::TimeWithZone)
        expect(created_order.projected_delivery_date).to be_an_instance_of(ActiveSupport::TimeWithZone)
        expect(created_order.adjustments.last.amount).to eq(-10.0)
        expect(created_order.adjustments.last.label).to eq('PROMO')
      end

      it 'allows update tracking numbers' do
        shipment = created_order.shipments.last
        expect(shipment.update_attributes(tracking: 'new_tracking_number')).to be_truthy
        expect(created_order.shipments.last.tracking).to eq('new_tracking_number')
      end

      it 'creates new order as new' do
        new_order = manual_order.save_order(correct_params.merge(status: 'new'))
        expect(new_order.number[0]).to eq('M')
      end

      it 'creates new order with correct product name' do
        expect(created_order.line_items.first.variant.product.name).to eq('Stylight')
      end

      it 'creates new order with correct user' do
        expect(created_order.user.first_name).to eq('John')
        expect(created_order.user.last_name).to eq('Doe')
        expect(created_order.user.email).to eq('john.doe@gmail.com')
      end

      it 'creates new order with correct ship_address' do
        expect(created_order.ship_address.firstname).to eq('John')
        expect(created_order.ship_address.lastname).to eq('Doe')
        expect(created_order.ship_address.email).to eq('john.doe@gmail.com')
        expect(created_order.ship_address.city).to eq('Los-Angeles')
        expect(created_order.ship_address.address1).to eq('Address1')
        expect(created_order.ship_address.address2).to eq('Address2')
        expect(created_order.ship_address.zipcode).to eq('61201')
        expect(created_order.ship_address.phone).to eq('+38094659031')
        expect(created_order.ship_address.country).to eq(country)
        expect(created_order.ship_address.state).to eq(state)
      end
    end

  end
end
