require 'spec_helper'

module SiteVersions
  describe Presenter do
    describe '#options_for_select' do
      before(:each) do
        SiteVersion.delete_all
        create(:site_version, permalink: 'au', name: 'Australia')
        create(:site_version, permalink: 'br', name: 'Brazil')
      end

      it 'returns a formatted array of site versions for a select_tag' do
        result = described_class.options_for_select
        expect(result).to eq([
          ["Australia" , "/site_versions/au" , {"data-flag-url"=>"/assets/flags/au.png"}],
          ["Brazil"    , "/site_versions/br" , {"data-flag-url"=>"/assets/flags/br.png"}]
        ])
      end
    end
  end
end
