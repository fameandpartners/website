require 'spec_helper'

describe 'Captures UTM data from the URL (for each order)', type: :feature do
  context 'no UTM params on the URL' do
    it do
      expect { visit('/contact') }.not_to change { Marketing::OrderTrafficParameters.count }
    end
  end

  context 'there are UTM params' do
    before(:each) do
      visit '/contact?utm_campaign=utm_campaign&utm_source=utm_source&utm_medium=utm_medium'
    end

    it 'captures UTM params on user visit' do
      utm = Marketing::OrderTrafficParameters.last
      expect(utm.utm_campaign).to eq('utm_campaign')
      expect(utm.utm_source).to eq('utm_source')
      expect(utm.utm_medium).to eq('utm_medium')
    end

    describe 'user visits website with other UTM params' do
      before(:each) do
        visit '/contact?utm_campaign=other&utm_source=different&utm_medium=medium'
      end

      #fails because no contentful versions
      # it 'does not create more than one traffic object' do
      #   expect(Marketing::OrderTrafficParameters.count).to eq(1)
      # end

      it 'updates his/her current order UTM attributes' do
        utm = Marketing::OrderTrafficParameters.last
        expect(utm.utm_campaign).to eq('other')
        expect(utm.utm_source).to eq('different')
        expect(utm.utm_medium).to eq('medium')
      end
    end
  end
end
