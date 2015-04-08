class CrappyProductFactory

  # let(:taxonomy)              { Spree::Taxonomy.create!(:name => 'Style') }
  # let(:taxon)                 { create(:taxon, :name => 'Style') }
  # let(:styles)                { %w{Strapless Lace V-Neck} }
  # let(:sizes)                 { (6..10).step(2) }
  # let(:colours)               { %w{black white green} }
  #
  # let(:color_type)  { Spree::OptionType.create!(:name => 'dress-color', :presentation => 'Color') }
  # let(:size_type)   { Spree::OptionType.create!(:name => 'dress-size', :presentation => 'Size') }
  #
  # def create_option_value(option_type, values)
  #   values.each_with_index.collect do |v, i|
  #     option_type.option_values.create(:name => v)
  #   end
  # end
  #
  #
  # def create_data
  #   create :taxon
  #   Spree::Taxonomy.create!(:name => 'Range')
  #
  #   size_options   = create_option_value(size_type, sizes)
  #   colour_options = create_option_value(color_type, colours)
  #
  #   taxons = styles.collect do |style|
  #     create(:taxon, :name => style, :parent => taxon, :taxonomy => taxonomy)
  #   end
  #
  #   taxons.each do |taxon|
  #     dresses = create_list(:dress, 3, :taxons => [taxon])
  #     dresses.each do |dress|
  #       colour_options.each do | colour_option |
  #         dress.product_color_values << ProductColorValue.new(:option_value => colour_option)
  #       end
  #       # size_options.each do | size_option |
  #       # ProductColorValue.create!(:option_value => size_option, :product => dress)
  #       # end
  #       # dress.variants << variants
  #       dress.option_types = [color_type, size_type]
  #       dress.save!
  #       # dress.reload
  #       size_options.each do | size_option |
  #         colour_options.each do | colour_option |
  #           Spree::Variant.create(product_id: dress.id).tap do |variant|
  #             variant.option_values = [size_option, colour_option]
  #             variant.save!
  #           end
  #         end
  #       end
  #     end
  #   end
  #
  #   # dresses.each_with_index do |dress, i|
  #   #   dress.taxons << taxons
  #   #   dress.save!
  #   # end
  #
  #   Utility::Reindexer.reindex
  # end


end