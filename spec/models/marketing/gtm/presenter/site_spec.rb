require 'spec_helper'

describe Marketing::Gtm::Presenter::Site, type: :presenter do
  let(:site_version) { build_stubbed(:site_version, permalink: 'au') }

  subject(:presenter) { described_class.new(current_site_version: site_version) }

  it_behaves_like 'a Marketing::Gtm::Presenter::Base'

  describe '#body' do
    context 'given a current_site_version' do
      it 'returns hash with site version data' do
        expect(subject.body).to eq({ version: 'au' })
      end
    end
  end
end
