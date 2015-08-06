module DataSteps
  step 'all production products are loaded' do

    raise 'Nope' if Rails.env.production?

    dump_file = File.join Rails.root, 'spec', 'support', 'snapshots', 'minified_production_data.dump'
    database = Rails.configuration.database_configuration[Rails.env]['database']

    %x( pg_restore -d #{database} --clean --if-exists --jobs 8 --no-acl -U postgres #{dump_file})

    Utility::Reindexer.reindex

  end

  step 'there is a default page' do
    Revolution::Page.create!(:path => '/dresses/*', :template_path => '/products/collections/show.html.slim').publish!
  end

  step 'there is a :dress_name dress' do |dress_name|
    # binding.pry

    FactoryGirl.create :dress, name: dress_name
    # create :dress, name: dress_name

    dress = {
      sku: '1234',
      name: dress_name
    }

    taxon = create :taxon

    color_type = Spree::OptionType.create!(:name => 'dress-color', :presentation => 'Color')
    size_type =  Spree::OptionType.create!(:name => 'dress-size', :presentation => 'Size')


    size_option = Spree::OptionType.where(name: 'dress-size').first
    color_option = Spree::OptionType.where(name: 'dress-color').first

    colors = ["light-pink", "pale-blue", "white", "lemon-sorbet"]
    sizes = [8,10,12]

    colors.each do |color_name|
      color_option.option_values.create name: color_name
    end

    sizes.each do |size_no|
      color_option.option_values.create name: size_no
    end
    #
    # def create_option_value(option_type, values)
    #   values.each_with_index.collect do |v, i|
    #     option_type.option_values.create(:name => v)
    #   end
    # end



    #  rake import:data FILE_PATH=~/fame/content/final_imported_images/cleaned_spreadsheets_v2/MasterContent_90sModelFinal_v1.xls
    dress = {
        :sku            => "4B307",
        :name           => "Mesh Belle",
        :sizes          => sizes,
        :price_in_aud   => 309.0,
        :price_in_usd   => 249.0,
        :description    => "<p>Let your inner princess rule. </p>\n\n<p>Mesh Belle is a mesh two piece dress featuring a textured bandeau crop top, grosgrain straps and a voluminous midi skirt with a fitted waistband, flattering pleats and a flirty mesh overlay</p>",
        :colors         => ["light-pink", "pale-blue", "white", "lemon-sorbet"],
        :taxon_ids      => [taxon.id],
        # :taxon_ids => [148, 158, 155, 185, 131, 147, 144, 191],
        :style_profile  => {
            :glam           => 8.0,
            :girly          => 9.0,
            :classic        => 7.0,
            :edgy           => 6.0,
            :bohemian       => 4.0,
            :sexiness       => 5.0,
            :fashionability => 8.0,
            :apple          => 6.0,
            :pear           => 9.0,
            :strawberry     => 6.0,
            :hour_glass     => 8.0,
            :column         => 9.0,
            :athletic       => 8.0,
            :petite         => 7.0},
        :properties     => {
            :style_notes         => "Make you & your dress the highlight of the night with classic pointed toe heels and fine silver jewelry. ",
            :fit                 => "Model wears AU 8 / US 4\nB: 83CM\nW: 65CM\nH: 89CM",
            :fabric              => "Main: Mesh and Dutchess satin\nLining: Matte stretch satin",
            :product_type        => nil,
            :product_category    => nil,
            :factory_id          => nil,
            :factory_name        => nil,
            :product_coding      => nil,
            :shipping            => nil,
            :stylist_quote_short => nil,
            :stylist_quote_long  => nil,
            :product_details     => "<p>Dry clean only</p>",
            :revenue             => 9.0,
            :cogs                => 6.0,
            :video_id            => nil,
            :color_customization => "Yes",
            :short_description   => nil},
        :song           => {:link => "https://soundcloud.com/officialmelanie/02-carousel", :name => nil},
        :customizations => [
            {:name => "MAKE SKIRT FULL LENGTH", :price => 19.99, :position => 1},
            {:name => "MAKE SKIRT ABOVE THE KNEE", :price => 9.99, :position => 2},
            {:name => "LENGTHEN TOP TO END AT WAIST", :price => 9.99, :position => 3}
        ]
    }


    bu = Products::BatchUploader.new(Date.yesterday)


    # binding.pry
    bu.create_or_update_products([dress])

    # binding.pry

    Utility::Reindexer.reindex

  end
end

RSpec.configure { |c| c.include DataSteps }



cool_dress = {
    :sku => "4B307",
    :name => "Mesh Belle",
    :price_in_aud => 309.0,
    :price_in_usd => 249.0,
    :description => "<p>Let your inner princess rule. </p>\n\n<p>Mesh Belle is a mesh two piece dress featuring a textured bandeau crop top, grosgrain straps and a voluminous midi skirt with a fitted waistband, flattering pleats and a flirty mesh overlay</p>",
    :colors => ["light-pink", "pale-blue", "white", "lemon-sorbet"],
    :taxon_ids => [148, 158, 155, 185, 131, 147, 144, 191],
    :style_profile => {
        :glam => 8.0,
        :girly => 9.0,
        :classic => 7.0,
        :edgy => 6.0,
        :bohemian => 4.0,
        :sexiness => 5.0,
        :fashionability => 8.0,
        :apple => 6.0,
        :pear => 9.0,
        :strawberry => 6.0,
        :hour_glass => 8.0,
        :column => 9.0,
        :athletic => 8.0,
        :petite => 7.0},
    :properties => {
        :style_notes => "Make you & your dress the highlight of the night with classic pointed toe heels and fine silver jewelry. ",
        :fit => "Model wears AU 8 / US 4\nB: 83CM\nW: 65CM\nH: 89CM",
        :fabric => "Main: Mesh and Dutchess satin\nLining: Matte stretch satin",
        :product_type => nil,
        :product_category => nil,
        :factory_id => nil,
        :factory_name => nil,
        :product_coding => nil,
        :shipping => nil,
        :stylist_quote_short => nil,
        :stylist_quote_long => nil,
        :product_details => "<p>Dry clean only</p>",
        :revenue => 9.0,
        :cogs => 6.0,
        :video_id => nil,
        :color_customization => "Yes",
        :short_description => nil},
    :song => {:link => "https://soundcloud.com/officialmelanie/02-carousel", :name => nil},
    :customizations => [
        {:name => "MAKE SKIRT FULL LENGTH", :price => 19.99, :position => 1},
        {:name => "MAKE SKIRT ABOVE THE KNEE", :price => 9.99, :position => 2},
        {:name => "LENGTHEN TOP TO END AT WAIST", :price => 9.99, :position => 3}
    ]
}
