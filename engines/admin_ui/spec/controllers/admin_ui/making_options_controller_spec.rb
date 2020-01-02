require 'rails_helper'

module AdminUi
  module Content
    RSpec.describe MakingOptionsController, :type => :controller do

      routes { AdminUi::Engine.routes }
      before(:each) do
        stub_admin_authorization!
        @making_option = MakingOption.new
        @form = Forms::MakingOptionForm.new(@making_option)
      end

      describe "GET index" do
        it 'should render success' do
          get :index
          expect(response.status).to eq(200)
        end
      end

      describe "GET new" do
        it 'should render success' do
          get :new
          expect(response.status).to eq(200)
          expect(response).to render_template(:new)
        end
      end

      describe "POST create" do
        let(:valid_params) {{
          code: 'M11D',
          name: 'A Swatch Delivery',
          description: '7~11 days',
          delivery_period: '7~11 days',
          making_time_business_days: 2,
          position: 25,
          delivery_time_days: 11
        }}

        it 'should go to edit page' do
          post :create, forms_making_option: valid_params
          expect(response).to be_redirect
        end
      end

      describe "GET edit" do
        it 'should render success' do
          expect(MakingOption).to receive(:find).with('123').and_return(@making_option)
          get :edit, id: 123

          expect(response.status).to eq(200)
        end
      end

      describe "PUT update" do
        it 'should update success' do
          expect(MakingOption).to receive(:find).with('123').and_return(@making_option)
          expect(Forms::MakingOptionForm).to receive(:new).with(@making_option).and_return(@form)
          expect(@form).to receive(:validate).and_return(true)
          expect(@form).to receive(:save).and_return(true)
          put :update, id: 123, forms_making_option: { code: 'M15D' }

          expect(flash[:success]).to be_present
          expect(response).to be_redirect
        end
      end

    end
  end
end
