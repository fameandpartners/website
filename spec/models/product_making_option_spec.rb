require 'spec_helper'

describe ProductMakingOption, type: :model do
  context '#assign_default_attributes' do
    let(:subject) { described_class.new }

    it 'set price' do
      subject.assign_default_attributes
      expect(subject.price).to eq(described_class::DEFAULT_OPTION_PRICE)
    end

    it 'sets currency' do
      expect(SiteVersion).to receive(:default).and_return(instance_double('sv', currency: 'USD'))
      subject.assign_default_attributes
      expect(subject.currency).to eq('USD')
    end
  end
end
