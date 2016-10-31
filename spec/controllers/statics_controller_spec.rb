require 'spec_helper'

shared_context 'super revolution page is created' do
  let(:us_translation) { Revolution::Translation.new(locale:           'en-US',
                                                     title:            'Super Page',
                                                     meta_description: 'Super Meta Description') }
  let(:br_translation) { Revolution::Translation.new(locale:           'pt-BR',
                                                     title:            'Super Página',
                                                     meta_description: 'Super Meta Descrição') }
  let(:page) { Revolution::Page.create(path: '/super-page', publish_from: 2.days.ago) }

  let(:us_site_version) { build(:site_version, locale: 'en-US') }
  let(:br_site_version) { build(:site_version, locale: 'pt-BR') }

  before(:each) do
    page.translations = [us_translation, br_translation]
    routes.draw { get 'super-page' => 'statics#super_page' }
  end
end

describe StaticsController, type: :controller do
  describe 'load CMS pages for localized meta descriptions and titles' do
    controller(described_class) do
      def super_page
        render text: 'ok!'
      end
    end

    context 'when a CMS page exists' do
      include_context 'super revolution page is created'

      it 'uses page meta description and title based on site version locale' do
        [
          [us_site_version, us_translation],
          [br_site_version, br_translation]
        ].each do |site_version, translation|
          allow(SiteVersion).to receive(:default).and_return(site_version)

          get :super_page
          expect(controller.instance_variable_get(:@title)).to eq(translation.title)
          expect(controller.instance_variable_get(:@description)).to eq(translation.meta_description)
          expect(controller.instance_variable_get(:@page)).to eq(page)
        end
      end
    end
  end

  describe '#getitquick_unavailable' do
    it 'expects a 404' do
      get :getitquick_unavailable
      expect(response).to render_template('getitquick_unavailable')
      expect(response).to have_http_status(:not_found)
    end
  end
end
