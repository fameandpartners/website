require 'spec_helper'

describe Concerns::SiteVersion, type: :controller do
  controller do
    include Concerns::SiteVersion

    def index
      render text: 'ok'
    end

    def create
      render text: 'create'
    end
  end

  describe 'before filters' do
    describe '#add_site_version_to_mailer' do
      let(:default_url_options) { { default: :hash } }

      before(:each) do
        allow(controller).to receive(:default_url_options).and_return(default_url_options)
      end

      it 'merges ActionMailer::Base.default_url_options with controller defaults' do
        expect(ActionMailer::Base).to receive_message_chain(:default_url_options, :merge!).with(default_url_options)
        get :index
      end
    end
  end

  describe '#site_version_param' do
    context 'params site version is set' do
      before(:each) { request.env['site_version_code'] = 'pt' }

      it 'returns the params site version' do
        expect(controller.site_version_param).to eq('pt')
      end
    end

    context 'params site version is not set' do
      let(:australian_site_version) { build_stubbed(:site_version, permalink: 'au', default: true) }

      before(:each) { expect(SiteVersion).to receive(:default).and_return(australian_site_version) }

      it 'returns the default site version code' do
        expect(controller.site_version_param).to eq('au')
      end
    end
  end

  describe '#default_url_options' do
    context 'given a site version detector' do
      let(:site_version_detector) { double('Site Version Detector') }
      let(:site_version) { double('Site Version') }

      before(:each) do
        allow(UrlHelpers::SiteVersion::Detector).to receive(:detector).and_return(site_version_detector)
        allow(controller).to receive(:current_site_version).and_return(site_version)
      end

      it 'delegates default_url_options to configured site version detector' do
        expect(site_version_detector).to receive(:default_url_options).with(site_version)
        controller.default_url_options
      end
    end
  end
end
