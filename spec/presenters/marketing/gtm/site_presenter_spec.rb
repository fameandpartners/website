require 'spec_helper'

describe Marketing::Gtm::SitePresenter, type: :presenter do
  it_behaves_like 'a Marketing::Gtm::BasePresenter'

  describe '#body' do
    context 'given a current_site_version' do
      let(:site_version) { build_stubbed(:site_version, permalink: 'au') }

      it 'returns hash with site version data' do
        presenter = described_class.new(current_site_version: site_version)
        expect(presenter.body).to eq({ version: 'au' })
      end
    end
  end
end
