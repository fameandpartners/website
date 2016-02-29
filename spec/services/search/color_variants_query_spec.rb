require 'spec_helper'

module Search
  RSpec.describe ColorVariantsQuery, type: :feature do

    context 'defaults' do
      subject(:default_query) { ColorVariantsQuery.build.to_hash }

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

    describe 'order' do
      describe 'default order' do
        it do
          query = ColorVariantsQuery.build({}).to_hash
          expect(query[:sort]).to include({"product.created_at"=>"desc"})
        end
      end

      context 'defined rules' do
        ordering_rules = [
          ['price_high',    {'product.price' => 'desc'}],
          ['price_low',     {'product.price' => 'asc'}],
          ['newest',        {'product.created_at' => 'desc'}],
          ['oldest',        {'product.created_at' => 'asc'}],
          ['fast_delivery', {'product.fast_delivery' => 'desc'}],
          ['best_sellers',  {'product.total_sales' => 'desc'}],
          ['alpha_asc',     {'product.name' => 'asc'}],
          ['alpha_desc',    {'product.name' => 'desc'}],
          ['created',       {'product.created_at' => 'desc'}]
        ]

        ordering_rules.each do |(ordering, expected_order_clause)|
          describe "#{ordering}" do
            it "#{ordering} queries #{expected_order_clause}" do
              ordering_option = {'order' => ordering}
              query           = ColorVariantsQuery.build(ordering_option).to_hash
              expect(query[:sort]).to include(expected_order_clause)
            end
          end
        end
      end
    end
  end
end
