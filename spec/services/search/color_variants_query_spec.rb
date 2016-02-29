require 'spec_helper'

module Search
  RSpec.describe ColorVariantsQuery, type: :feature do

    context 'defaults' do
      subject(:default_query) { Search::ColorVariantsQuery.build.to_hash }

      it 'sorts by product.created_at' do
        expect(default_query[:sort]).to eq [{"product.created_at"=>"desc"}]
      end

      describe 'filtering' do

        subject(:filter_clauses) {  default_query[:filter][:and]  }

        def boolean_filter_clause(term)
          {:bool => {:must => {:term => term}}}
        end

        it 'removes deleted items' do
          is_expected.to include boolean_filter_clause("product.is_deleted" => false)
        end

        it 'removes hidden items' do
          is_expected.to include boolean_filter_clause("product.is_hidden" => false)
        end

        it 'removes outerwear (jackets) items' do
          is_expected.to include boolean_filter_clause("product.is_outerwear" => false)
        end

        it 'includes in_stock items' do
          is_expected.to include boolean_filter_clause("product.in_stock" => true)
        end

        it 'requires available_on' do
          is_expected.to include({:exists=>{:field=>:available_on}})
        end
      end
    end
  end
end
