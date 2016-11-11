require 'spec_helper'

module BatchUpload
  describe Render3dImagesUploader do
    let(:parts)    { described_class::FileParser.new(file_name: file_name).values }
    let(:data)     { parts.first }
    let(:error)    { parts.last }

    let(:file_name) { self.class.description }

    context 'name should be parsed:' do
      context '4B141-PLUM-C1.jpg' do
        it { expect(data[:sku]).to eq '4b141' }
        it { expect(data[:color]).to eq 'plum' }
        it { expect(data[:customisation]).to eq 'c1' }
        it { expect(error).to be_nil }
      end

      context '4B141-SAGE-GREEN-C2.jpg' do
        it { expect(data[:sku]).to eq '4b141' }
        it { expect(data[:color]).to eq 'sage-green' }
        it { expect(data[:customisation]).to eq 'c2' }
        it { expect(error).to be_nil }
      end

      context '4B141-RED-D.jpg' do
        it { expect(data[:sku]).to eq '4b141' }
        it { expect(data[:color]).to eq 'red' }
        it { expect(data[:customisation]).to eq 'd' }
        it { expect(error).to be_nil }
      end

      context 'C161009-HOT PINK-C3.jpg' do
        it { expect(data[:sku]).to eq 'c161009' }
        it { expect(data[:color]).to eq 'hot-pink' }
        it { expect(data[:customisation]).to eq 'c3' }
        it { expect(error).to be_nil }
      end

      context 'C161009-PEACH-C1.jpg' do
        it { expect(data[:sku]).to eq 'c161009' }
        it { expect(data[:color]).to eq 'peach' }
        it { expect(data[:customisation]).to eq 'c1' }
        it { expect(error).to be_nil }
      end
    end

    context 'name should NOT be parsed:' do
      context '' do
        it { expect(error).to be_present }
        it { expect(error[:message]).to eq "File name is invalid and can't be parsed: ''" }
      end

      context 'this-is_test' do
        it { expect(error).to be_present }
        it { expect(error[:message]).to eq "File name is invalid and can't be parsed: 'this-is_test'" }
      end

      # NOTE: Alexey Bobyrev 08/11/16
      # Yes, this name is incorrect. It contains cyrillic letter here - С1
      context 'C161009-PEACH-С1.jpg' do
        it { expect(error).to be_present }
        it { expect(error[:message]).to eq "File cannot be parsed due to cyrrilic symbols on it - 'C161009-PEACH-С1.jpg':14" }
      end
    end

  end
end
