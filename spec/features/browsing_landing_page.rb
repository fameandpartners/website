require 'spec_helper'
require 'capybara/poltergeist'

describe 'user', type: :feature, js: true do

  before :all do
    Capybara.javascript_driver = :poltergeist
    ensure_environment_set
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
      ignore_js_errors { visit('/') }
    end

    it "contains menu links" do
      expect(page).to have_content 'Shop'
      expect(page).to have_content(/Formal dresses for every event/i)
    end

    it "shows empty shopping bag" do
      first('.js-trigger-shopping-bag')
      wait_ajax_completion(page)

      expect(page).to have_selector('#cart', visible: true)
      expect(page).to have_selector('#cart .cart--call-to-actions', visible: true)
    end

    it "allows redirect to /dresses page" do
      first('#home-menu .dresses').hover

      ignore_js_errors do
        find('#rect-dresses').click_link('View all dresses')
      end

      expect(page.status_code).to eq(200) # 200 OK
    end
  end
end
