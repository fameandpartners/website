require 'spec_helper'

describe 'browse and purchase process', :type => :feature do

  # let!(:dresses)              { create_list(:dress, 5) }
  let(:taxonomy)              { Spree::Taxonomy.create!(:name => 'Style') }
  let(:taxon)                 { create(:taxon, :name => 'Style') }
  # let!(:taxons)               { create_list(:taxon, 5, :parent => taxon, :taxonomy => taxonomy) }
  let(:styles)                { %w{Two-Piece Split Strapless Lace V-Neck Lace} }

  def create_option_value(option_type, values)
    values.each_with_index.collect do |v, i|
      option_type.option_values.create(:name => v)
    end
  end

  def create_data
    Spree::Taxonomy.create!(:name => 'Range')

    color_type = Spree::OptionType.create!(:name => 'color', :presentation => 'Color')
    size_type = Spree::OptionType.create!(:name => 'dress-size', :presentation => 'Size')

    taxons = styles.collect do |style|
      create(:taxon, :name => style, :parent => taxon, :taxonomy => taxonomy)
    end

    size_options = create_option_value(size_type, %w{1 2 3 5 8 13 21 34})
    colour_options = create_option_value(color_type, %w{black white green})
    
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
        size_options.each do | colour_option |
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
    Utility::Reindexer.reindex
  end

  before do    
    create_data 
  end

  context "authenticated" do
    include_context 'authenticated_user'
    
    describe 'browse' do
  
      it 'should add a product to cart' do
        visit '/us/'     
        p = Spree::Product.all.shuffle.first                

        click_link(p.taxons.first.name)        
        # click_link(p.name)
        visit "dresses/#{p.permalink}/"
        # require 'pry'; pry binding
      end

    end
  end
end