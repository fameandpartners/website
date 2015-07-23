require 'spec_helper'

module Concerns
  RSpec.describe AutomaticDiscount, type: :controller do
    controller do
      include AutomaticDiscount

      def index
        render text: ''
      end
    end

    describe 'is a concern' do
      it do
        expect(controller).to respond_to :apply_automatic_discount_code
      end

      it 'before hooks are applied' do
        expect(controller).to receive(:apply_automatic_discount_code)
        get :index
      end
    end

    describe '#auto_apply_discount_key' do
      it { expect(controller.send(:auto_apply_discount_param_key)).to eq(:faadc) }
    end

    describe '#auto_apply_discount_retry_key' do
      it { expect(controller.send(:auto_apply_discount_retry_key)).to eq(:auto_apply_promo) }
    end

    describe '#automatic_discount_code' do
      subject { controller.automatic_discount_code }

      describe 'when a code is supplied' do
        it do
          get :index, :faadc => '12345'

          is_expected.to eq '12345'
        end

        it 'sets the code value on the session' do
          get :index, :faadc => '12345'
          expect(controller.session[:auto_apply_promo]).to eq '12345'
        end

        it 'uses an unapplied promo code in the session as well' do
          controller.session[:auto_apply_promo] = "existing_promo_code"

          get :index

          is_expected.to eq "existing_promo_code"
        end
      end

      describe 'when a code is supplied' do
        it do
          get :index, :faadc => '12345'

          is_expected.to eq '12345'
        end
      end
    end

    describe '#apply_automatic_discount_code' do
      describe 'returns early' do

        subject { controller.apply_automatic_discount_code }

        describe 'for non GET requests' do
          %i(post head put).each do |http_method|
            it "for http #{http_method} method" do
              send(http_method, :index)

              is_expected.to eq :not_get_request
            end
          end
        end

        it 'when no code is provided' do
          get :index

          is_expected.to eq :no_code_provided
        end

        it 'when code is already applied to the cart' do
          dummy_order = instance_spy('Spree::Order', promocode: 'FAMElovesDRESSES')
          allow(controller).to receive(:current_order).and_return(dummy_order)

          get :index, :faadc => 'FAMElovesDRESSES'
          is_expected.to eq :already_on_order
        end
      end

      describe 'applies promotion code' do
        it 'only for GET requests' do
          get :index
          expect(controller.apply_automatic_discount_code).to_not eq :not_get
        end

        it 'when a code is supplied' do
          expect_any_instance_of(UserCart::PromotionsService).to receive(:apply)

          get :index, :faadc => 'awesome_yo'
        end
      end
    end
  end
end
