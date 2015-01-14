require 'spec_helper'

describe 'browse and purchase process', :type => :feature do

  # let!(:dresses)              { create_list(:dress, 5) }
  let(:taxonomy)              { Spree::Taxonomy.create!(:name => 'Style') }
  let(:taxon)                 { create(:taxon, :name => 'Style') }
  # let!(:taxons)               { create_list(:taxon, 5, :parent => taxon, :taxonomy => taxonomy) }
  let(:styles)                { %w{Empire-Waist Sequins One-Shoulder Two-Piece Split Strapless Lace V-Neck} }


  before do    
    Products::ColorVariantsIndexer.index!
    Spree::Taxonomy.create!(:name => 'Range')

    color_type = Spree::OptionType.create!(:name => 'color', :presentation => 'Color')

    taxons = styles.collect do |style|
      create(:taxon, :name => style, :parent => taxon, :taxonomy => taxonomy)
    end

    colour_options = %w{black white green}.each_with_index.collect do |color, i|
      Spree::OptionValue.new(:name => color).tap do | o |
        o.option_type = color_type
        o.position = i
        o.save!     
      end
    end
    
    # require 'pry'; pry binding

    taxons.each do |taxon|
      dresses = create_list(:dress, 5, :taxons => [taxon])
      dresses.each do |dress|
        colour_options.each do | colour_option |
          p = ProductColorValue.new
          p.option_value = colour_option
          p.product = dress
          p.save!
        end
      end
    end

    # dresses = taxons.collect do |
    # dresses.each_with_index do |dress, |
    #   dress.taxons << taxons
    #   dress.product_color_values << product_color_values

    #   dress.save!
    # end

    Tire.index(:spree_products) do
      delete
      import Spree::Product.all
    end

    Products::ColorVariantsIndexer.index!
  end

  context "authenticated" do
    include_context 'authenticated_user'
    
    describe 'browse' do
  
      it 'should add a product to cart' do
        visit '/us/'     
      end

    end
  end
end