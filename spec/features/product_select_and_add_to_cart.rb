require 'spec_helper'
require 'capybara/poltergeist'

describe 'user', type: :feature, js: true do
  include PathBuildersHelper

  before :all do
    ensure_environment_set(force: true)

    create(:spree_product, :with_size_color_variants, position: 1)
  end

  context 'products list' do
    before :all do
      update_elastic_index
    end

    before :each do
      ignore_js_errors { visit('/dresses') }
    end

    it "allow user to view products" do
      expect(page).to have_css('.products-collection .category--item')
    end

    it "allow user to move to dress details" do
      ignore_js_errors do
        first('.products-collection .category--item a img').click
      end

      expect(page).to have_css('#slides')
      expect(page).to have_css('.product-content')
    end
  end

  context "product details" do
    let(:product) { Spree::Product.first }

    before :each do
      Rails.cache.clear # side panels cache doesn't reload automatically, btw
      Spree::Order.delete_all

      ignore_js_errors do
        visit collection_product_path(product)
      end
    end

    it "can add dress to cart" do
      sleep(0.5)
      # select color. color will be select by default.. we can omit
      find('#product-colorize-action').click()
      first('#product-color-content .color-option').click()

      # ensure panel closed
      find('#product-overlay', visible: false).trigger('click')

      # select size
      find("#product-size-action").click
      first('#product-size-content .size-option.product-option').click

      # ensure panel closed
      find('#product-overlay', visible: false).trigger('click')

      # press 'add'
      find('.buy-button', visible: false).trigger("click")

      wait_ajax_completion(page)

      # item should be
      expect(page.first('.js-cart-item-count').text).to eq('1')
      expect(page).to have_selector('#cart .cart-items .cart-item', visible: true)

      # internally, we should have items in order too
      order_id = page.get_rack_session["order_id"]
      order = Spree::Order.find(order_id)

      expect(order).not_to be_blank
      expect(order.item_count).to eq(1)
    end
  end
end
