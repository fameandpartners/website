require 'spec_helper'

RSpec.describe 'shared/tracking/_google_analytics.html.erb', type: :view do

  it 'renders nothing without an active Spree Tracker' do
    render
    expect(rendered).to match /\A\n\n\z/
  end


  it 'sets GA account ID from Spree::Tracker' do
    allow(Spree::Tracker)
      .to receive(:current)
            .and_return(Spree::Tracker.new(analytics_id: 'onetwothreefourfive,sixseveneightnineten,eleventwelve' ))

    tracker_id = Regexp.escape("_gaq.push(['_setAccount', 'onetwothreefourfive,sixseveneightnineten,eleventwelve']);")

    render
    expect(rendered).to match tracker_id
  end

  context 'with valid tracker' do
    before do
      allow(Spree::Tracker)
        .to receive(:current)
              .and_return(Spree::Tracker.new(analytics_id: 'whatever'))
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
          expect(rendered).to match(Regexp.escape(expected_output))
        end
      end
    end

    describe 'commerce / order tracking' do
      let(:google_add_transaction)  { Regexp.escape("_gaq.push(['_addTrans',") }
      let(:expected_order_number)   { 'O999888777' }

      let(:spree_order) { build :complete_order_with_items, number: expected_order_number }

      before do
        allow(view).to receive(:current_site_version).and_return(SiteVersion.new)
        assign :spree_order, spree_order
      end

      it 'smoke test' do
        flash[:commerce_tracking] = 'truthy'
        render

        expect(rendered).to match google_add_transaction
        expect(rendered).to match expected_order_number
        expect(rendered).to match Regexp.escape("_gaq.push(['_addItem',")
        expect(rendered).to match Regexp.escape(spree_order.line_items.first.variant.sku)
        expect(rendered).to match Regexp.escape(spree_order.bill_address.city)
        expect(rendered).to match Regexp.escape("198.37")
        expect(rendered).to match Regexp.escape("_gaq.push(['_trackTrans']);")
      end

      describe 'requires triggering' do
        it 'without trigger' do
          render
          expect(rendered).not_to match google_add_transaction
          expect(rendered).not_to match expected_order_number
        end

        it ':force_tracking' do
          params[:force_tracking] = 'truthy'
          render
          expect(rendered).to    match google_add_transaction
          expect(rendered).to    match expected_order_number
        end

        it ':commerce_tracking' do
          flash[:commerce_tracking] = 'truthy'
          render
          expect(rendered).to    match google_add_transaction
          expect(rendered).to    match expected_order_number
        end
      end
    end
  end
end
