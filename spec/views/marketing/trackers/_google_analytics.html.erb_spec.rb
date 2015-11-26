require 'spec_helper'

describe 'marketing/trackers/_google_analytics.html.erb', type: :view do
  it 'renders nothing without an active Spree Tracker' do
    render
    expect(rendered).to be_blank
  end

  context 'with valid tracker' do
    before do
      allow(Spree::Tracker).to receive(:current).and_return(Spree::Tracker.new(analytics_id: 'whatever'))
    end

    it 'sets GA account ID from Spree::Tracker' do
      render
      expect(rendered).to include "_gaq.push(['_setAccount', 'whatever']);"
    end

    describe 'feature flags' do
      context ':test_analytics' do
        context 'is enabled' do
          before { Features.activate(:test_analytics) }

          it 'has setDomainName analytics configuration' do
            render
            expect(rendered).to include("_gaq.push(['_setDomainName', 'none']);")
          end

          context 'is disalbed' do
            it 'does not have setDomainName' do
              expect(rendered).not_to include('_setDomainName')
            end
          end
        end
      end
    end

    describe 'simple facebook events' do
      {
        track_fb_reminder_promo: "_gaq.push(['_trackEvent', 'Facebook', 'Redeem']);",
        track_fb_signin:         "_gaq.push(['_trackEvent', 'Facebook', 'SignIn']);",
        track_fb_signup:         "_gaq.push(['_trackEvent', 'Facebook', 'SignUp']);",
      }.map do |flash_key, expected_output|
        it "tracks :#{flash_key} event" do
          flash[flash_key] = 'truthy'
          render
          expect(rendered).to include expected_output
        end
      end
    end

    describe 'user registration events' do
      context 'user just signed up' do
        before { flash.now[:signed_up_just_now] = true }

        it 'pushes registration complete event to dataLayer' do
          render
          expect(rendered).to include("dataLayer.push({event: \"registrationCompleted\"});")
        end
      end

      context 'user already signed up' do
        it 'does not renders anything related to complete registration' do
          render
          expect(rendered).not_to include('registrationCompleted')
        end
      end
    end

    describe 'commerce / order tracking' do
      let(:expected_order_number)   { 'O999888777' }

      let(:spree_order) { build :complete_order_with_items, number: expected_order_number, currency: 'AUD' }

      before do
        allow(view).to receive(:current_site_version).and_return(SiteVersion.new)
        assign :spree_order, spree_order
      end

      it 'smoke test' do
        flash[:commerce_tracking] = 'truthy'
        render

        expect(rendered).to include "_gaq.push(['_addTrans',"
        expect(rendered).to include expected_order_number
        expect(rendered).to include "_gaq.push(['_addItem',"
        expect(rendered).to include spree_order.line_items.first.variant.sku
        expect(rendered).to include spree_order.bill_address.city
        expect(rendered).to include "198.37"
        expect(rendered).to include "_gaq.push(['_trackTrans']);"
        expect(rendered).to include "_gaq.push(['_set', 'currencyCode', 'AUD']);"
      end

      describe 'requires triggering' do
        it 'without trigger' do
          render
          expect(rendered).not_to include "_gaq.push(['_addTrans',"
          expect(rendered).not_to include expected_order_number
        end

        it ':force_tracking' do
          params[:force_tracking] = 'truthy'
          render
          expect(rendered).to include "_gaq.push(['_addTrans',"
          expect(rendered).to include expected_order_number
        end

        it ':commerce_tracking' do
          flash[:commerce_tracking] = 'truthy'
          render
          expect(rendered).to include "_gaq.push(['_addTrans',"
          expect(rendered).to include expected_order_number
        end
      end
    end
  end
end
