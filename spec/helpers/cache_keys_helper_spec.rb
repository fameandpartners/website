require 'spec_helper'

RSpec.describe CacheKeysHelper, :type => :helper do
  describe "#price_sensitive_cache_key" do
    context 'with promo code' do
      before do
        def helper.current_promotion
          Spree::Promotion.new code: 'freestuff'
        end

        def helper.current_site_version
          SiteVersion.new permalink: 'mars'
        end
      end

      it "uses the site and current promotion" do
        expect(helper.price_sensitive_cache_key).to eql("site=mars,promo=freestuff")
      end
    end

    context 'no promo code' do
      before do
        def helper.current_promotion
          nil
        end

        def helper.current_site_version
          SiteVersion.new permalink: 'venus'
        end
      end
      it "ignores missing promotions" do
        expect(helper.price_sensitive_cache_key).to eql("site=venus,promo=")
      end
    end
  end
end
