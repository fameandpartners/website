require 'spec_helper'

describe Concerns::SiteVersion, type: :controller do
  controller do
    include Concerns::SiteVersion
  end

  before(:each) { SiteVersion.delete_all }

  describe '#site_versions_enabled?' do
    it 'tells if there is more than one site version available' do
      create(:site_version)
      expect(controller.site_versions_enabled?).to be_falsy

      create(:site_version)
      expect(controller.site_versions_enabled?).to be_truthy
    end
  end

  describe '#current_site_version' do
    pending 'This method needs refactoring'
  end

  describe '#param_site_version' do
    context 'params site version is set' do
      before(:each) { controller.params[:site_version] = 'pt' }

      it 'returns the params site version' do
        expect(controller.param_site_version).to eq('pt')
      end
    end

    context 'params site version is not set' do
      let(:australian_site_verison) { create(:site_version, permalink: 'au', default: true) }

      before(:each) { expect(SiteVersion).to receive(:default).and_return(australian_site_verison) }

      it 'returns the default site version code' do
        expect(controller.param_site_version).to eq('au')
      end
    end
  end
end