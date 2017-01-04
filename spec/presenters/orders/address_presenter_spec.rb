require 'spec_helper'

RSpec.describe Orders::AddressPresenter do
  let(:address) do
    build_stubbed(:address,
                  firstname: 'Name',
                  lastname: 'Surname',
                  address1: 'Line1',
                  address2: 'Line2',
                  state: build_stubbed(:state, name: 'AU State'),
                  state_name: 'State',
                  city: 'Melbourn',
                  zipcode: '1234',
                  phone: '5678',
                  email: 'fake@mail.com')
  end

  subject { described_class.new(address) }

  describe 'delegated attributes' do
    it 'delegates attributes to spree address' do
      %i(firstname lastname address1 address2 state state_name city zipcode phone email).each do |field|
        expect(subject.send(field)).to eq(address.send(field))
      end
    end
  end

  describe '#full_name' do
    it 'concatenates firstname and lastname' do
      expect(subject.full_name).to eq('Name Surname')
    end

    it 'returns lastname when firstname is nil' do
      is_expected.to receive(:firstname).and_return(nil)

      expect(subject.full_name).to eq('Surname')
    end

    it 'returns firstname when lastname is nil' do
      is_expected.to receive(:lastname).and_return(nil)

      expect(subject.full_name).to eq('Name')
    end
  end

  describe '#address_lines' do
    it "concatenates address lines" do
      expect(subject.address_lines).to eq('Line1 Line2')
    end

    it 'returns address1 if address2 is nil' do
      is_expected.to receive(:address2).and_return(nil)

      expect(subject.address_lines).to eq('Line1')
    end

    it 'returns address2 if address1 is nil' do
      is_expected.to receive(:address1).and_return(nil)

      expect(subject.address_lines).to eq('Line2')
    end
  end

  describe '#state_code' do
    it "fetches state's name if state is present" do
      expect(subject.state_code).to eq('AU State')
    end

    it 'returns state_name if state is nil' do
      is_expected.to receive(:state).and_return(nil)

      expect(subject.state_code).to eq('State')
    end
  end

  describe 'city_with_state' do
    it 'concatenates city with state using comma' do
      expect(subject.city_with_state).to eq('Melbourn, AU State')
    end

    it 'returns state if city is nil' do
      is_expected.to receive(:city).and_return(nil)

      expect(subject.city_with_state).to eq('AU State')
    end

    it 'returns city if state is nil' do
      is_expected.to receive(:state_code).and_return(nil)

      expect(subject.city_with_state).to eq('Melbourn')
    end
  end
end
