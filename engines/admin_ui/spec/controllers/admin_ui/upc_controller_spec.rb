require 'rails_helper'

module AdminUi
  module Content
    RSpec.describe UpcController, :type => :controller do

      routes { AdminUi::Engine.routes }
      before(:each) { stub_admin_authorization! }

      describe "GET index" do
        it 'should redirect to new route' do
          get :index
          expect(response).to redirect_to(new_content_upc_url)
        end
      end

      describe "GET new" do
        it 'should render page' do
          get :new
          expect(response.status).to eq(200)
          expect(response).to render_template(:new)
        end
      end

      describe "POST create" do
        before do
          allow(controller).to receive(:find_or_create_sku) { create(:global_sku)}
        end

        let(:color_option_type) { FactoryGirl.create(:option_type, :color) }
        let(:size_option_type) { FactoryGirl.create(:option_type, :size) }
        let(:dress) { FactoryGirl.create(:dress, name: 'Bianca Dress', sku: 'ABC123') }

        let(:valid_params) {{
          style_number: dress.sku,
          style_name: dress.name,
          height: 'standard',
          color_name: color_option_type.name,
          color_presentation_name: color_option_type.name,
          sizes: [size_option_type.name]
        }}

        it 'should render new template' do
          post :create, sku_upc: valid_params
          expect(response.status).to eq(200)
          expect(response).to render_template(:new)
        end
      end

    end
  end
end
