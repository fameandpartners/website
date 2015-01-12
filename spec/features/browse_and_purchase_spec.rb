require 'spec_helper'

describe 'browse and purchase process', :type => :feature do

  let!(:dresses) { create_list(:dress, 5) }

  before do    
    Products::ColorVariantsIndexer.index!
    Spree::Taxonomy.create!(name: 'Range')
    dress = dresses.first
    # dress.product_color_values << create(:product_color_value)
    # puts dress.class
    puts dress.product_color_values.inspect
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