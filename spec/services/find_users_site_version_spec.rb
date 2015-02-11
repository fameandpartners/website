require 'spec_helper'

describe FindUsersSiteVersion do
  context "#get" do
    before(:each) { SiteVersion.delete_all }

    let!(:site_version) { create(:site_version) }

    it "returns site version choosen by user previously" do
      user = create(:spree_user, site_version_id: site_version.id)

      service = FindUsersSiteVersion.new(user: user)
      expect(service.get).to eq(site_version)
    end

    it "returns site version choosen by guest user" do
      sv = create(:site_version)

      service = FindUsersSiteVersion.new(cookie_param: sv.permalink)
      expect(service.get).to eq(sv)
    end

    it "returns site version choosen by remote ip"

    it "returns site version choosen by passing a param" do
      sv = create(:site_version)
      service = FindUsersSiteVersion.new(url_param: sv.permalink)
      allow(service).to receive(:sv_choosen_by_location).and_return(nil)

      expect(service.get).to eq(sv)
    end

    it "returns default site version" do
      sv = create(:site_version, default: true)
      service = FindUsersSiteVersion.new({})
      allow(service).to receive(:sv_choosen_by_location).and_return(nil)

      expect(service.get).to eq(sv)
    end
  end
end
