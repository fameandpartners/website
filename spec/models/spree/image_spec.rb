require 'rails_helper'

RSpec.describe Spree::Image, type: :model do
  it { is_expected.to validate_presence_of(:attachment).with_message("can't be empty") }

  it { expect(described_class.attachment_definitions[:attachment][:path]).to eq(':rails_root/public/spree/products/:id/:style/:basename.:extension') }
end
