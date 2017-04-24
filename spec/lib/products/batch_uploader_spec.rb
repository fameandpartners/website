require 'spec_helper'

describe Products::BatchUploader do
  @disabled = true
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
    allow( Spree::Taxon).to receive( :find ).and_return([
                                                          build_stubbed(:blank_taxon,
                                                                        id: 1002,
                                                                        name: 'Daywear',
                                                                        position: 0
                                                                       )
                                                        ]
                                                       )

    allow(Spree::OptionType).to receive(:where).with( name: 'dress-size' ).and_return([
                                                                                         build_stubbed(:option_type,
                                                                                                       name: 'dress-size',
                                                                                                       presentation: "Size",
                                                                                                       position: 0
                                                                                                      )
                                                                                       ] )
    
    allow(Spree::OptionType).to receive(:where).with( name: 'dress-color' ).and_return([
                                                                                         build_stubbed(:option_type,
                                                                                                       name: 'dress-color',
                                                                                                       presentation: "Color",
                                                                                                       position: 0
                                                                                                      )
                                                                                       ] )
    allow_any_instance_of(Spree::Product).to receive(:update_index).and_return(true)    
    allow_any_instance_of(Spree::Product).to receive(:index).and_return(true)    
    allow_any_instance_of(Tire).to receive(:index).and_return(true)    
    allow_any_instance_of(Tire::Model::Search::InstanceMethodsProxy).to receive(:update_index).and_return(true)    


  end

  it "should be able to run the constructor" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect( batch_uploader).not_to eq(nil)
  end unless @disabled

  it "should be able to parse a simple sheet" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect(batch_uploader.parse_file( 'spec/test_data/test_batch_import.xlsx' ) ).to eq( true )
  end unless @disabled

  it "should be able to detect that cad data is present" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect(batch_uploader.has_cad_data?( 'spec/test_data/test_batch_import_with_cads.xlsx' ) ).to eq( true )
    expect(batch_uploader.has_cad_data?( 'spec/test_data/test_batch_import.xlsx' ) ).to eq( false )
  end unless @disabled

  
  it "should be able to parse the cads in the upload sheet" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect(batch_uploader.parse_file( 'spec/test_data/test_batch_import_with_cads.xlsx' ) ).to eq( true )
    data = batch_uploader.parsed_data

    expect( data.first[:cads] ).not_to eq( nil )
    expect( data.first[:cads].length ).to eq( 6 )

    expect( data.first[:cads].first[:customization_1] ).to eq( false )
    expect( data.first[:cads].first[:customization_2] ).to eq( false )
    expect( data.first[:cads].first[:customization_3] ).to eq( true )
    expect( data.first[:cads].first[:customization_4] ).to eq( true )
    expect( data.first[:cads].first[:base_image_name] ).to eq( "base_3_4.png" )
    expect( data.first[:cads].first[:layer_image_name] ).to eq( nil )
    
  end unless @disabled


  it "should be able to create a new product" do
    batch_uploader = Products::BatchUploader.new( Date.today )
    expect(batch_uploader.parse_file( 'spec/test_data/test_batch_import.xlsx' ) ).to eq( true )
    data = batch_uploader.parsed_data

    batch_uploader.create_or_update_products(data)

  end 
  
end
