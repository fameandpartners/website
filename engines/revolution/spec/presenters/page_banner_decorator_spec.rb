require 'spec_helper'

describe Revolution::PageBannerDecorator do

  let(:path)           { '/blah/vtha' }

  let(:params)         { {} }
  let(:page)           { Revolution::Page.new(:path => path) }
  subject!(:presenter) { Revolution::PageBannerDecorator.new(page, params) }

  context "disable banner" do
    let(:params) { {:lpi => 'none'} }

    it { expect(presenter.display?).to eq false }
  end

  context "custom banner" do
    let(:params) { {:lpi => 'blah'} }

    it { expect(presenter.display?).to eq true }
    it { expect(presenter.custom?).to eq true }
  end

  context "default banner" do
    before do
      allow(page).to receive(:banner_image).and_return('vtha')
    end

    it { expect(presenter.display?).to eq true }
    it { expect(presenter.custom?).to eq false }
    it { expect(presenter.image).to eq page.banner_image }
  end
end
