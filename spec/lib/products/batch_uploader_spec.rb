require 'spec_helper'

describe Products::BatchUploader do
  before(:each) do
    allow(Spree::Taxonomy).to receive(:where).with( name: 'Range' ).and_return([
                               build_stubbed(:taxonomy, 
                                             name: 'Range',
                                             position: 0
                                            )
                             ]
                           ) 
    allow(Spree::Taxon).to receive(:where).and_return([
                               build_stubbed(:blank_taxon, 
                                             name: 'Daywear',
                                             position: 0
                                            )
                             ]
                           ) 
    allow(Spree::OptionType).to receive(:where).with( name: 'dress-color' ).and_return([
                                                                                         build_stubbed(:option_type,
                                                                                                       name: 'dress-color',
                                                                                                       presentation: "Color",
                                                                                                       position: 0
                                                                                                      )
                                                                                       ] )
  end

  it "should be able to run the constructor" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect( batch_uploader).not_to eq(nil)
  end

  it "should be able to parse a simple sheet" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect(batch_uploader.parse_file( 'spec/test_data/test_batch_import.xlsx' ) ).to eq( true )
  end
end
