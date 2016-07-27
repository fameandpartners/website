require 'spec_helper'
require 'ostruct'

module Repositories
  RSpec.describe ProductSize do

    let(:site_version) { build_stubbed(:site_version) }

    context 'characterisation' do
      context 'without sizes / variants' do
        let(:product) { create :dress }
        subject(:size_repo) { described_class.new(site_version: site_version, product: product) }

        it('there are no sizes') { expect(size_repo.read_all).to       be_empty }
        it('there are no sizes') { expect(size_repo.class.read_all).to be_empty }
      end

      context 'with sizes, but no products' do
        let(:product) { create :dress }
        subject(:size_repo) { described_class.new(site_version: site_version, product: product) }

        let!(:existing_size) do
          create :product_size, size_template: 8
        end

        describe "class /instance #read_all behaves differently" do
          it { expect(size_repo.class.read_all).not_to be_empty }
          it { expect(size_repo.read_all).to           be_empty }
        end


        let(:expected_size) {
          OpenStruct.new(
            id:              existing_size.id,
            name:            "US8/AU12",
            value:           "US8/AU12",
            presentation:    "US 8/AU 12",
            presentation_au: "AU 12",
            presentation_us: "US 8",
            sort_key:        8,
            extra_price:     nil
          )
        }

        it "class method allows access to raw OpenStruct" do
          expect(size_repo.class.read_all).to eq [expected_size]
        end

        it do
          expect(size_repo.class.read(existing_size.id)).to eq expected_size
        end

      end

      context 'with sizes, and products' do
        let(:product_variants) { Repositories::ProductVariants.new(product_id: product.id).read_all }

        let(:product) { create :dress_with_variants }
        subject(:size_repo) do
          described_class.new(
            site_version:     site_version,
            product:          product,
            product_variants: product_variants
          )
        end

        let!(:existing_size) do
          create :product_size, size_template: 7
        end

        describe "class /instance #read_all behaves differently" do
          it { expect(size_repo.class.read_all).not_to be_empty }
          xit { expect(size_repo.read_all).not_to       be_empty }
        end

        it "class method allows access to raw OpenStruct" do
          size_struct = OpenStruct.new(
            id:              existing_size.id,
            name:            "US7/AU11",
            value:           "US7/AU11",
            presentation:    "US 7/AU 11",
            presentation_au: "AU 11",
            presentation_us: "US 7",
            sort_key:        7,
            extra_price:     nil
          )

          expect(size_repo.class.read_all).to include size_struct
        end
      end




    end
  end
end

