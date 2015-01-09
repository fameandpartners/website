require 'spec_helper'

describe 'browse and purchase process', :type => :feature do

  let(:dresses) { create_list(:dress, 5) }

  before do
    Spree::Taxonomy.create!(name: 'Range')
    puts dresses.inspect   
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