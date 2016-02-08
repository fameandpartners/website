require 'spec_helper'

describe 'browse and purchase process', :type => :feature do
  let(:taxonomy)              { Spree::Taxonomy.create!(:name => 'Style') }
  let(:taxon)                 { create(:taxon, :name => 'Style') }
  let(:styles)                { %w{Strapless Lace V-Neck} }
  let(:sizes)                 { (6..10).step(2) }
  let(:colours)               { %w{black white green} }

  let(:color_type)  { Spree::OptionType.create!(:name => 'dress-color', :presentation => 'Color') }
  let(:size_type)   { Spree::OptionType.create!(:name => 'dress-size', :presentation => 'Size') }

  def create_option_value(option_type, values)
    values.each_with_index.collect do |v, i|
      option_type.option_values.create(:name => v)
    end
  end

  def create_data
    Spree::Taxonomy.create!(:name => 'Range')

    size_options   = create_option_value(size_type, sizes)
    colour_options = create_option_value(color_type, colours)

    taxons = styles.collect do |style|
      create(:taxon, :name => style, :parent => taxon, :taxonomy => taxonomy)
    end

    taxons.each do |taxon|
      dresses = create_list(:dress, 3, :taxons => [taxon])
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
    allow(image).to receive(:attachment_file_name).and_return('abc')
    allow_any_instance_of(ProductColorValue).to receive(:images).and_return([image])
    create_data
  end

  context 'surfing' do

    describe 'test UI' do

      it 'display correct UI', :chrome do
        visit '/search?q=test-non-existing-dress'
        expect(page.find('.page-title')).to have_content "We couldn't find the stuff you were looking for."
        name = Spree::Product.first.name
        visit "/search?q=#{name.gsub(" ","+")}"
        expect(page.find('.page-title')).to have_content "RESULTS FOR"

        visit '/lookbook'
        expect(page.find('.panel-hero h1').text).to eq("Great Minds Think Alike".upcase)

        visit "/dresses"
        price_filter = page.find('.filter-area-prices')
        expect(price_filter).to have_content("View all prices")
        expect(price_filter).to have_content("$0 - $199")
        expect(price_filter).to have_content("$200 - $299")
        expect(price_filter).to have_content("$300 - $399")
        expect(price_filter).to have_content("$400+")

        style_taxons = Spree::Taxon.where(name: 'Style').first.children
        style_filter = page.find('.filter-area-styles')
        expect(style_filter).to have_content("view all styles")
        style_taxons.each do |t|
          expect(style_filter).to have_content(t.name.downcase)
        end

        login_user
        visit "/profile"
        expect(page.find("#profile_first_name").value).to eql(Spree::User.first.first_name)
        expect(page.find("#profile_last_name").value).to eql(Spree::User.first.last_name)
        visit "/logout"
      end
    end

    describe 'browse' do
      # TODO - Actually make this a test. :)
      xit 'should add a product to cart' do
        visit '/us/'
        p = Spree::Product.all.shuffle.first
        find('.nav-menu').click_link("Lace")

        # visit "dresses/#{p.permalink}/"
      end
    end
  end
end
