require 'spec_helper'

RSpec.describe Factory, :type => :model do
  context 'validations' do
    it do
      expect(described_class.new).to validate_presence_of :name
    end
  end
end
