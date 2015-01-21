require 'spec_helper'

describe 'browse and purchase process', :type => :feature do

  # let!(:dresses)              { create_list(:dress, 5) }
  let(:taxonomy)              { Spree::Taxonomy.create!(:name => 'Style') }
  let(:taxon)                 { create(:taxon, :name => 'Style') }
  # let!(:taxons)               { create_list(:taxon, 5, :parent => taxon, :taxonomy => taxonomy) }
  let(:styles)                { %w{Two-Piece Split Strapless Lace V-Neck} }

  def create_option_value(option_type, values)
    values.each_with_index.collect do |v, i|
      option_type.option_values.create(:name => v)
    end
  end

  def create_data
    Spree::Taxonomy.create!(:name => 'Range')

    color_type = Spree::OptionType.create!(:name => 'dress-color', :presentation => 'Color')
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
          dress.product_color_values << ProductColorValue.new(:option_value => colour_option)          
        end
        # size_options.each do | size_option |
          # ProductColorValue.create!(:option_value => size_option, :product => dress)
        # end
        # dress.variants << variants
        dress.option_types = [color_type, size_type]
        dress.save!
        # dress.reload
        size_options.each do | size_option |        
          colour_options.each do | colour_option |        
            Spree::Variant.create(product_id: dress.id).tap do |variant|
              variant.option_values = [size_option, colour_option]
              variant.save!
            end
          end
        end
      end
    end

    # dresses.each_with_index do |dress, i|
    #   dress.taxons << taxons
    #   dress.save!
    # end    

    Utility::Reindexer.reindex

  end

  before do      
    image = double(Spree::Image)
    allow(image).to receive_message_chain(:attachment, :url).and_return('/images/missing.png')
    allow_any_instance_of(ProductColorValue).to receive(:images).and_return([image])

    create_data 
  end

  context "authenticated" do
    include_context 'authenticated_user'
    
    describe 'browse' do
  
      it 'should add a product to cart' do
        visit '/us/'     
        p = Spree::Product.all.shuffle.first                        
        click_link('Lace')
        # click_link(p.name)
        visit "dresses/#{p.permalink}/"
      end

    end
  end
end