require 'spec_helper'

describe ProductMakingOption, type: :model do
  it "exists" do
    expect(ProductMakingOption.new).not_to be_blank
  end

  context "#assign_default_attributes" do
    let(:subject) { ProductMakingOption.new }

    it "set price" do
      subject.assign_default_attributes
      expect(subject.price).to eq(ProductMakingOption::DEFAULT_OPTION_PRICE)
    end

    it "sets currency" do
      expect(SiteVersion).to receive(:default).and_return(instance_double('sv', currency: 'USD'))
      subject.assign_default_attributes
      expect(subject.currency).to eq("USD")
    end
  end
end
