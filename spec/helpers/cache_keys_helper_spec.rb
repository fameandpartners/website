require 'spec_helper'

RSpec.describe CacheKeysHelper, :type => :helper do

  before do
    class << helper
      attr_reader :current_site_version, :current_promotion
    end

    helper.instance_variable_set(:@current_site_version, current_site_version)
    helper.instance_variable_set(:@current_promotion,    current_promotion)
  end

  describe "#price_sensitive_cache_key" do

    let(:current_site_version) { SiteVersion.new permalink: 'mars' }
    let(:current_promotion)    { Spree::Promotion.new code: 'freestuff' }

    context 'with promo code' do
      it "uses the site and current promotion" do
        expect(helper.price_sensitive_cache_key).to eql("site=mars,promo=freestuff")
      end
    end

    context 'no promo code' do

      let(:current_site_version) { SiteVersion.new permalink: 'venus' }
      let(:current_promotion)    { nil }

      it "ignores missing promotions" do
        expect(helper.price_sensitive_cache_key).to eql("site=venus,promo=")
      end
    end
  end
end
