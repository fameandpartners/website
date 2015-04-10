require 'spec_helper'

  describe UserCart::PromotionsService do
    describe '#promtion_code?' do

      let(:order)   { double('Order') }
      let(:promo_code) { 'UPPERCASE' }

      let(:options) { {:order => order, :code => promo_code} }

      subject(:promo) do
        UserCart::PromotionsService.new(options)
      end

      it 'code should be downcased' do
        expect(promo.code).to eq 'uppercase'
      end

    end
  end

