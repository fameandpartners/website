require 'spec_helper'

RSpec.describe MailChimp::Store, type: :model do

  describe('::Exists', :vcr) do

    it('should check if store exists') do
      result = described_class::Exists.()
      expect(result).to eql(false)
    end
  end

  describe('::Create', :vcr) do

    it('should create store') do
      result = described_class::Create.()
      expect(result).to eql(true)
    end
  end
end
