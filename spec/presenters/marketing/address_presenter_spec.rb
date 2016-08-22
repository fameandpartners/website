require 'spec_helper'

module Marketing
  describe AddressPresenter, type: :presenter do
    let(:state) { build_stubbed(:state, name: 'Another State') }
    let(:country) { build_stubbed(:country, name: 'United States of Amerikyeah') }
    let(:address) { build_stubbed(
      :address,
      address1:          'Street da Lorota',
      address2:          'Around the corner',
      alternative_phone: '1234-5678',
      city:              'Los Angeles',
      company:           'Lorotinha da Silva Sauro',
      country:           country,
      email:             'loroteiro@silvestre.com',
      firstname:         'Loroteiro',
      lastname:          'Silvestre',
      phone:             '9876-54242',
      state:             state,
      state_name:        'Californya',
      zipcode:           '123-312',
    ) }
    let(:presenter) { described_class.new(address) }

    describe 'delegates to Spree::Address' do
      it('#address1') { expect(presenter.address1).to eq('Street da Lorota') }
      it('#address2') { expect(presenter.address2).to eq('Around the corner') }
      it('#alternative_phone') { expect(presenter.alternative_phone).to eq('1234-5678') }
      it('#city') { expect(presenter.city).to eq('Los Angeles') }
      it('#company') { expect(presenter.company).to eq('Lorotinha da Silva Sauro') }
      it('#email') { expect(presenter.email).to eq('loroteiro@silvestre.com') }
      it('#firstname') { expect(presenter.firstname).to eq('Loroteiro') }
      it('#lastname') { expect(presenter.lastname).to eq('Silvestre') }
      it('#phone') { expect(presenter.phone).to eq('9876-54242') }
      it('#state_name') { expect(presenter.state_name).to eq('Californya') }
      it('#zipcode') { expect(presenter.zipcode).to eq('123-312') }
    end

    describe 'instance methods' do
      describe '#state' do
        it('returns state\'s name') { expect(presenter.state).to eq('Another State') }
      end

      describe '#country' do
        it('returns country\'s name') { expect(presenter.country).to eq('United States of Amerikyeah') }
      end

      describe '#to_h' do
        it 'returns hash of presenter attributes' do
          expect(presenter.to_h).to eq({
                                         address1:          'Street da Lorota',
                                         address2:          'Around the corner',
                                         alternative_phone: '1234-5678',
                                         city:              'Los Angeles',
                                         company:           'Lorotinha da Silva Sauro',
                                         country:           'United States of Amerikyeah',
                                         email:             'loroteiro@silvestre.com',
                                         firstname:         'Loroteiro',
                                         lastname:          'Silvestre',
                                         phone:             '9876-54242',
                                         state:             'Another State',
                                         zipcode:           '123-312'
                                       })
        end
      end
    end
  end
end
