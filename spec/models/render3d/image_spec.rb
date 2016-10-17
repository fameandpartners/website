require 'rails_helper'

RSpec.describe Render3d::Image, type: :model do
  it { is_expected.to validate_presence_of :customisation_value }
  it { is_expected.to validate_presence_of :product_color_value }
  it { is_expected.to validate_presence_of :product }
  it { is_expected.to validate_presence_of(:attachment).with_message("can't be empty") }

  it { expect(subject.attachment.options[:url]).to eq('/spree/products/render3d/:id/:style/:basename.:extension') }
end
