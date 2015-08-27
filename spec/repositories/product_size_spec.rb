require 'spec_helper'
require 'ostruct'

module Repositories
  RSpec.describe ProductSize do

    before :each do
      # Sigh
      ProductSize.instance_variable_set(:@sizes_map, nil)
      Spree::Variant.instance_variable_set(:@size_option_type, nil)
    end

    context 'characterisation' do
      context 'without sizes / variants' do
        let(:site_version) { seed_site_zone }

        let(:product) { create :dress }
        subject(:size_repo) { described_class.new(site_version: site_version, product: product) }

        it('there are no sizes') { expect(size_repo.read_all).to       be_empty }
        it('there are no sizes') { expect(size_repo.class.read_all).to be_empty }
      end

      context 'with sizes, but no products' do
        let(:site_version) { seed_site_zone }

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
                      id:           existing_size.id,
                      name:         "8",
                      presentation: "8",
                      value:        8)
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

        let(:site_version) { seed_site_zone }

        let(:product) { create :dress_with_variants }
        subject(:size_repo) do
          described_class.new(
            site_version:     site_version,
            product:          product,
            product_variants: product_variants
          )
        end

        let!(:existing_size) do
          create :product_size, size_template: 8
        end

        describe "class /instance #read_all behaves differently" do
          it { expect(size_repo.class.read_all).not_to be_empty }
          xit { expect(size_repo.read_all).not_to       be_empty }
        end

        it "class method allows access to raw OpenStruct" do
          size_struct = OpenStruct.new(
            id:           existing_size.id,
            name:         "8",
            presentation: "8",
            value:        8)

          expect(size_repo.class.read_all).to eq [size_struct]
        end
      end




    end
  end
end

