require 'spec_helper'

module Revolution

    RSpec.describe BannersController, type: :controller do

      routes { Revolution::Engine.routes }

      let(:path)      { '/blah/vtha' }
      let(:locale)    { 'en-AU' }
      let(:title)     { 'Blah Vtha' }

      let(:page) { Revolution::Page.create(path: path) }
      let!(:translation) { page.translations.create!(locale: locale, title: title, meta_description: title) }
      let(:banner) { Revolution::Banner.create!(translation_id:      translation.id,
                                                             alt_text:            'alt text',
                                                             banner_order:        1,
                                                             size:                'full',
                                                             banner_file_name:    'image1.jpg',
                                                             banner_content_type: 'image/jpeg') }

      describe "GET delete" do
        before(:each) do
          get :delete, banner_id: banner.id
        end
        it { expect(response).to redirect_to("#{request.base_url}/fame_admin/content/pages/#{page.id}/edit") }
        it { expect(flash[:success]).to eq('Banner deleted') }
        it { expect(assigns(:banner)).to eq(banner) }
        it { expect(Revolution::Banner.count).to eq(0) }

      end

    end
end




