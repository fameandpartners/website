require 'rails_helper'

RSpec.describe Spree::Image, type: :model do
  it { is_expected.to validate_presence_of(:attachment).with_message("can't be empty") }
  it { expect(subject.attachment.options[:url]).to eq('/spree/products/:id/:style/:basename.:extension') }
end
