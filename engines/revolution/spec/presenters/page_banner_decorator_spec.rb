require 'spec_helper'

describe Revolution::PageBannerDecorator do
  let(:path)           { '/blah/vtha' }

  let(:params)         { {} }
  let(:page)           { Revolution::Page.new(path: path) }
  subject!(:presenter) { Revolution::PageBannerDecorator.new(page, params) }

  context 'disable banner' do
    let(:params) { { lpi: 'none' } }

    it { expect(presenter.display?).to eq false }
  end

  context 'custom banner' do
    let(:params) { { lpi: 'blah' } }

    it { expect(presenter.display?).to eq true }
    it { expect(presenter.custom?).to eq true }
  end

  context 'default banner' do
    before do
      allow(page).to receive(:banner_image).and_return('vtha')
    end

    it { expect(presenter.display?).to eq true }
    it { expect(presenter.custom?).to eq false }
    it { expect(presenter.image).to eq page.banner_image }
  end

  describe '#asset_safe_page_path' do
    it 'leaves normal values alone' do
      expect(presenter.asset_safe_page_path).to eq path
    end
  end

  context 'Root dresses/* style URLs' do
    let(:path)   { '/dresses/*' }
    let(:params) { { lpi: 'wedontneednosteenkingtests' } }

    describe '#asset_safe_page_path' do
      it 'removes /* from paths' do
        expect(presenter.asset_safe_page_path).to eq '/dresses'
      end
    end

    describe 'can have custom banners too' do
      it { expect(presenter.image).to_not include path }
      it { expect(presenter.image).to_not include '*' }
      it { expect(presenter.image).to eq 'http://localhost/pages/dresses/wedontneednosteenkingtests.jpg' }
    end
  end
end
