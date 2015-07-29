require 'spec_helper'

describe FindUsersSiteVersion, type: :service, memoization_support: true do
  describe "#get" do
    before(:each) do
      SiteVersion.delete_all
      rememoize(SiteVersion, :@default)
    end

    it "returns site version chosen by user previously" do
      sv = create(:site_version)
      user = create(:spree_user, site_version_id: sv.id)

      service = described_class.new(user: user)
      expect(service.get).to eq(sv)
    end

    it "returns site version chosen by guest user (cookie based)" do
      sv = create(:site_version)

      service = described_class.new(cookie_param: sv.permalink)
      expect(service.get).to eq(sv)
    end

    it "returns site version chosen by remote ip" do
      sv = create(:site_version, permalink: 'au')
      australian_ip = '202.138.0.0'

      service = described_class.new(request_ip: australian_ip)
      expect(service.get).to eq(sv)
    end

    it "returns site version chosen by passing a param (site version permalink)" do
      sv = create(:site_version)

      service = described_class.new(url_param: sv.permalink)
      expect(service.get).to eq(sv)
    end

    it "returns default site version" do
      sv = create(:site_version, default: true)

      service = described_class.new({})
      expect(service.get).to eq(sv)
    end


    describe 'order of precedence' do
      it 'prefers url params over ip address' do
        user         = nil
        url_param    = 'au'
        cookie_param = nil
        request_ip   = "127.0.0.1"

        service = FindUsersSiteVersion.new(
          user:         user,
          url_param:    url_param,
          cookie_param: cookie_param,
          request_ip:   request_ip
        )

        dummy_site_version = instance_spy('SiteVersion')

        expect(service).to receive(:find_by_permalink).with('au').and_return(dummy_site_version)
        expect(service.get).to eq dummy_site_version
      end
    end
  end
end
