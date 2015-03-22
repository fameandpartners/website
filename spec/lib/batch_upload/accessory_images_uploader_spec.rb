require 'active_support/core_ext'
require 'pry'

require_relative '../../../lib/batch_upload/accessory_images_uploader'

module BatchUpload
  describe AccessoryImagesUploader do
    let(:uploader)   { AccessoryImagesUploader.new '' }
    let(:parts)      { uploader.split_filename(file_name) }
    let(:position)   { parts.first }
    let(:style_name) { parts.last }

    # Magic!
    let(:file_name) { self.class.description }

    context 'Boho1.jpg' do
      it { expect(position).to eq 1 }
      it { expect(style_name).to eq 'bohemian'}
    end

    context 'Edgy1.jpg' do
      it { expect(position).to eq 1 }
      it { expect(style_name).to eq 'edgy'}
    end

    context 'Edgy 3.jpg' do
      it { expect(position).to eq 3 }
      it { expect(style_name).to eq 'edgy'}
    end

    context 'after4 .jpg' do
      it { expect(position).to eq 4 }
      it { expect(style_name).to eq 'after'}
    end

    context 'surrounding 3 .jpg' do
      it { expect(position).to eq 3 }
      it { expect(style_name).to eq 'surrounding'}
    end
  end
end
