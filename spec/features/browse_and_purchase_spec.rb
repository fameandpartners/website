require 'spec_helper'
require 'capybara/poltergeist'

# data helpers
def update_elastic_index
  # two steps for easier debug
  Products::ColorVariantsIndexer.new.tap do |indexer|
    indexer.collect_variants
    indexer.push_to_index
  end
end

def clean_old_test_data
  Spree::Image.delete_all
  Spree::Product.destroy_all
  Spree::Taxon.delete_all
  Spree::Taxonomy.delete_all
  Spree::PaymentMethod.destroy_all
end

# behaviour tests
# don't forgot to clear traffic before
#   page.driver.clear_network_traffic
def show_network_traffic(page)
  page.driver.network_traffic.each do |request|
    request.response_parts.uniq(&:url).each do |response|
      puts "\n Responce URL #{response.url}: \n Status #{response.status}"
    end
  end
end

def wait_ajax_completion(page)
  Timeout.timeout(Capybara.default_wait_time) do
    while !page.evaluate_script('jQuery.active').zero? do
      sleep(0.1)
    end
    sleep(0.5) # additional time to process & render
  end
end

def select_from_chosen(option_value, options)
  field = find_field(options[:from], visible: false)
  page.execute_script("$('##{field[:id]}').val('#{option_value}')")
  page.execute_script("$('##{field[:id]}').trigger('chosen:updated').trigger('change')")
end

# debug tools
# page.driver.debug # if inspector true
# save_and_open_screenshot
# save_and_open_page
# save_screenshot('screenshot.png', full: true)
# ..

describe 'user', type: :feature, js: true do
  include PathBuildersHelper

  before :all do
    Capybara.javascript_driver = :poltergeist

    clean_old_test_data

    create(:taxonomy, :collection)
    create(:taxonomy, :style)
    Repositories::Taxonomy.read_all(force: true)

    create(:option_type, :size, :with_values)
    create(:option_type, :color, :with_values_groups)

    create(:shipping_method)

    create(:state) # spree#state, us country will be created automatically

    create(:pin_gateway) # we need to recreate

    product = create(:spree_product, :with_size_color_variants, position: 1)
    product.reload
  end

  before :each do
    Spree::Order.delete_all
    Rails.cache.clear
  end

  context "robots" do
    # simpliest request ever
    it 'shows robots txt' do
      visit '/robots.txt'
      expect(page).to have_text('User-Agent')
      expect(page.status_code).to eq(200) # 200 OK
    end
  end

  context "#landing_page" do
    before :each do
      begin
        visit '/'
      rescue Capybara::Poltergeist::JavascriptError
      end
    end

    it "contains menu links" do
      expect(page).to have_content 'Shop'
    end

    it "contains banner box"

    it "contains email registration" do
      expect(page).to have_content(/Become Famous/i)

      # TODO : check email capturing
    end

    it "shows empty shopping bag" do
      find('#cart-trigger a').click
      wait_ajax_completion(page)

      expect(page).to have_selector('#cart', visible: true)
      expect(page).to have_selector('#cart .cart--call-to-actions', visible: true)

      # TODO check not empty dress
    end

    it "allows redirect to /dresses page" do
      first('.shop.menu-item').hover

      begin
        find('.nav-menu ul.primary .all-dresses').click_button('View all dresses')
      rescue Capybara::Poltergeist::JavascriptError
      end

      expect(page.status_code).to eq(200) # 200 OK
    end
  end

  context 'products list' do
    before :all do
      update_elastic_index
    end

    before :each do
      begin
        visit '/dresses'
      rescue Capybara::Poltergeist::JavascriptError
      end
    end

    it "allow user to view products" do
      expect(page).to have_css('.products-collection .category--item')
    end

    it "allow user to move to dress details" do
      begin
        first('.products-collection .category--item a img').click
      rescue Capybara::Poltergeist::JavascriptError
      end

      expect(page).to have_css('#slides')
      expect(page).to have_css('.product-content')
    end
  end

  context "product details" do
    let(:product) { Spree::Product.first }

    before :each do
      Spree::Order.destroy_all

      begin
        visit collection_product_path(product)
      rescue Capybara::Poltergeist::JavascriptError
      end
    end

    it "can add dress to cart" do
      # select color. color will be select by default.. we can omit
      find('#product-colorize-action').click()
      first('#product-color-content .color-option').click()

      # select size
      find("#product-size-action").click
      first('#product-size-content .size-option.product-option').click

      # close panel
      find('#product-overlay').trigger('click')

      # press 'add'
      find('.buy-button').click

      wait_ajax_completion(page)

      # item should be
      expect(page.find('#cart-item-count').text).to eq('1')
      expect(page).to have_selector('#cart .cart-items .cart-item', visible: true)
order = Spree::Order.last
      expect(order).not_to be_blank
      expect(order.item_count).to eq(1)
    end
  end

  context "#checkout" do
    # otherwise, items created inside :each loop, will be not available in request processing
    before :all do
      DatabaseCleaner.strategy = DatabaseCleaner::NullStrategy
    end

    after :all do
      DatabaseCleaner.strategy = :transaction
    end

    before :each do
      Spree::Order.destroy_all
    end

    let(:currency)  { SiteVersion.default.currency }
    let(:product)   { Spree::Product.first }
    let(:order)     { create(:spree_order, currency: currency) }

    let(:user)      { build(:spree_user) }
    let(:address)   { build(:address) }

    let(:state)     { Spree::State.find_by_abbr('AL') }
    let(:country)   { state.try(:country) }

    # create user
    # create order with user
    # create payment methods
    it 'allows user to purchase item' do
      order.line_items = [ create(:dress_item, variant_id: product.variants.first.id) ]

      page.set_rack_session(
        order_id: order.id,
        access_token: order.token,
        country_code: SiteVersion.default.zone.members.first.zoneable.iso
      )

      begin
        visit '/checkout'
      rescue Capybara::Poltergeist::JavascriptError
      end

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

      select_from_chosen(country.id, from: 'order_bill_address_attributes_country_id')
      select_from_chosen(state.id, from: 'order_bill_address_attributes_state_id')

      begin
        find('button[name=pay_securely]').click
      rescue Capybara::Poltergeist::JavascriptError
      end

      within('.checkout-form.credit_card') do
        fill_in 'number',     with: 5520000000000000
        fill_in 'name',       with: 'John Smith'
        fill_in 'month',      with: Time.current.month
        fill_in 'year',       with: Time.current.year
        fill_in 'card_code',  with: '123'
      end

      begin
        find('.checkout-form button.btn').click
        wait_ajax_completion(page)
      rescue Capybara::Poltergeist::JavascriptError
      end

      sleep(10)

      order.reload
      expect(order.state).to eq('complete')
      expect(order.payment_state).to eq('paid')

      # fill payment step
      #save_screenshot('screenshot.png', full: true)
    end
  end
end
