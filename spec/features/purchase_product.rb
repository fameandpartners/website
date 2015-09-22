require 'spec_helper'
require 'capybara/poltergeist'

describe 'user', type: :feature, js: true do
  context "#checkout" do
    # otherwise, items created inside :each loop, will be not available in request processing
    before :all do
      Capybara.javascript_driver = :poltergeist
      Capybara.default_wait_time = 20
      DatabaseCleaner.strategy = DatabaseCleaner::NullStrategy

      ensure_environment_set
    end

    after :all do
      DatabaseCleaner.strategy = :transaction
      Capybara.default_wait_time = 10
    end

    before :each do
      Spree::Order.delete_all
      Spree::Product.delete_all
    end

    let(:currency)  { SiteVersion.default.currency }
    let(:product)   { create(:spree_product, :with_size_color_variants, position: 1) }
    let(:order)     { create(:spree_order, currency: currency) }

    let(:user)      { build(:spree_user) }
    let(:address)   { build(:address) }

    let(:state)     { Spree::State.find_by_abbr('AL') }

    let(:card)      { build(:credit_card, :master) }

    # create user
    # create order with user
    # create payment methods
    it 'allows user to purchase item' do
      product.reload # i'm sorry, product have cached variants relation
      order.line_items = [ create(:dress_item, variant_id: product.variants.first.id) ]

      page.set_rack_session(
        order_id: order.id,
        access_token: order.token,
        country_code: SiteVersion.default.zone.members.first.zoneable.iso
      )

      ignore_js_errors { visit '/checkout' }

      # fill address step
      within('.checkout-form') do
        fill_in 'order_bill_address_attributes_email',     with: user.email
        fill_in 'order_bill_address_attributes_firstname', with: address.firstname
        fill_in 'order_bill_address_attributes_lastname',  with: address.lastname
        fill_in 'order_bill_address_attributes_address1',  with: address.address1
        fill_in 'order_bill_address_attributes_city',      with: address.city
        fill_in 'order_bill_address_attributes_phone',     with: address.phone
        fill_in 'order_bill_address_attributes_zipcode',   with: address.zipcode

        choose 'ship_to_address_Ship_to_this_address'
      end

      select_from_chosen(state.country_id, from: 'order_bill_address_attributes_country_id')
      select_from_chosen(state.id, from: 'order_bill_address_attributes_state_id')

      ignore_js_errors { find('button[name=pay_securely]').click }

      within('.checkout-form.credit_card') do
        fill_in 'number',     with: card.number
        fill_in 'name',       with: card.name
        fill_in 'month',      with: card.month
        fill_in 'year',       with: card.year
        fill_in 'card_code',  with: card.verification_value
      end

      ignore_js_errors { find('.checkout-form button.btn').click }

      wait_ajax_completion(page)
      #sleep(10) # i'm sorry, have no idea how to stop execution until payment process finished

      # i'm sorry, have no idea how to stop execution until payment process finished
      # no more fast payments, 'pay with pain'
      begin
        Timeout.timeout(Capybara.default_wait_time) do
          while order.state != 'complete'
            sleep(0.1)
            order.reload
          end
        end
      rescue Timeout::Error
      end

      order.reload
      expect(order.state).to eq('complete')
      expect(order.payment_state).to eq('paid')
    end
  end
end
