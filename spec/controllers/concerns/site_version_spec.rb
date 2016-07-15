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
    describe '#guarantee_session_site_version' do
      let(:au_site_version) { build_stubbed(:site_version, permalink: 'au') }

      before(:each) do
        allow(controller).to receive(:current_site_version).and_return(au_site_version)
      end

      it 'sets site version session variable to current site version code' do
        expect(session[:site_version]).to be_nil
        get :index
        expect(session[:site_version]).to eq 'au'
      end
    end

    describe '#enforce_param_site_version' do
      let(:australian_site_version) { create(:site_version, permalink: 'au') }
      let(:brazilian_site_version)  { create(:site_version, permalink: 'br') }

      context 'site version param is different than current site version code' do
        before(:each) { controller.instance_variable_set(:@current_site_version, brazilian_site_version) }

        it 'sets the requested version as the current site version' do
          request.env['site_version_code'] = australian_site_version.code
          get :index

          current_site_version = controller.instance_variable_get(:@current_site_version)
          expect(current_site_version).to eq(australian_site_version)
        end

        describe 'does not change the current site version' do
          after(:each) do
            current_site_version = controller.instance_variable_get(:@current_site_version)
            expect(current_site_version).to eq(brazilian_site_version)
          end

          it 'when it is a non GET request' do
            post :create, { site_version: australian_site_version }
          end

          it 'when it is a AJAX request' do
            xhr :post, :create, { site_version: australian_site_version }
          end

          it 'when it is a request to /checkout path' do
            allow(request).to receive(:path).and_return('/checkout')
            get :index, { site_version: australian_site_version }
          end
        end
      end
    end

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

  describe '#current_site_version' do
    let(:au_site_version) { build_stubbed(:site_version, permalink: 'au') }
    let(:finder_double) { double('FindUsersSiteVersion instance', get: au_site_version) }

    it 'calls FindUsersSiteVersion service object' do
      expect(FindUsersSiteVersion).to receive(:new).with(user: nil, url_param: 'au', cookie_param: 'us').and_return(finder_double)

      request.env['site_version_code']  = 'au'
      controller.session[:site_version] = 'us'

      expect(controller.current_site_version).to eq(au_site_version)
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

  describe '#set_site_version' do
    it 'raises ArgumentError if no param is passed' do
      expect { controller.set_site_version }.to raise_error(ArgumentError)
    end

    context 'given a new site version' do
      let(:user)            { create(:spree_user) }
      let(:order)           { build(:spree_order) }
      let(:au_site_version) { build(:site_version, id: 101, permalink: 'au') }

      subject(:subject_method) { controller.set_site_version(au_site_version) }

      before(:each) do
        expect(order).to receive(:use_prices_from).with(au_site_version)
        allow(controller).to receive_messages(current_spree_user: user, session_order: order)
        subject_method
      end

      it { expect(controller.instance_variable_get(:@current_site_version)).to eq au_site_version }
      it { expect(session[:site_version]).to eq 'au' }
      it { expect(user.site_version_id).to eq 101 }
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
