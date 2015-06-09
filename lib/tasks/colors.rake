namespace :colors do
  task :import_from_file => :environment do
    option_type = Spree::OptionType.color
    option_values = YAML.load(File.open(File.join(Rails.root, 'lib', 'color', 'map.yml'))) rescue []

    option_values.each do |option_value|
      option_type.option_values.
        where(option_value.slice(:name)).
        first_or_create(option_value.slice(:presentation)).
        update_attributes(option_value.slice(:value, :image))
    end
  end

  task :export_to_file => :environment do
    option_type = Spree::OptionType.color
    stored_values = YAML.load(File.open(File.join(Rails.root, 'lib', 'color', 'map.yml'))) rescue []
    if stored_values.present?
      new_values = stored_values
      option_type.option_values.each do |color|
        color_definition = { name: color.name, presentation: color.presentation, value: color.value }
        index = new_values.index {|object| object[:name] == color.name }
        if index.present?
          new_values[index] = color_definition
        else
          new_values.push(color_definition)
        end
      end
    else
      new_values = option_type.option_values.map do |color|
        { name: color.name, presentation: color.presentation, value: color.value }
      end
    end
    File.open(File.join(Rails.root, 'lib', 'color', 'map.yml'), 'w+'){|f| f.puts new_values.to_yaml}
  end


  task :import => :environment do
    option_type = Spree::OptionType.color
    option_values = [
      {
        name: 'black',
        presentation: 'Black',
        value: '#000000'
      }, {
        name: 'red',
        presentation: 'Red',
        value: '#ED0234'
      }, {
        name: 'green',
        presentation: 'Green',
        value: '#269C36'
      }, {
        name: 'blue',
        presentation: 'Blue',
        value: '#15558B'
      }, {
        name: 'pink',
        presentation: 'Pink',
        value: '#FF3B9D'
      }, {
        name: 'gray',
        presentation: 'Gray',
        value: '#A3A7A8'
      }, {
        name: 'yellow',
        presentation: 'Yellow',
        value: '#FFE100'
      }, {
        name: 'orange',
        presentation: 'Orange',
        value: '#FF8434'
      }, {
        name: 'white',
        presentation: 'White',
        value: '#FFFFFF'
      }, {
        name: 'blood-red',
        presentation: 'Blood Red',
        value: '#C00D1D'
      }, {
        name: 'jade-green',
        presentation: 'Jade Green',
        value: '#006D43'
      }, {
        name: 'peach',
        presentation: 'Peach',
        value: '#FFC598'
      }, {
        name: 'silver',
        presentation: 'Silver',
        value: '#D0D1CC'
      }, {
        name: 'tiffany-blue',
        presentation: 'Tiffany Blue',
        value: '#0AB9B7'
      }, {
        name: 'cherry-red',
        presentation: 'Cherry Red',
        value: '#B91B29'
      }, {
        name: 'hunter-green',
        presentation: 'Hunter Green',
        value: '#003200'
      }, {
        name: 'lime-green',
        presentation: 'Lime Green',
        value: '#ADD418'
      }, {
        name: 'lemon',
        presentation: 'Lemon',
        value: '#F3D623'
      }, {
        name: 'ice-blue',
        presentation: 'Ice Blue',
        value: '#9BD8D9'
      }, {
        name: 'bright-orange',
        presentation: 'Bright Orange',
        value: '#FF7800'
      }, {
        name: 'bright-blue',
        presentation: 'Bright Blue',
        value: '#01A7F6'
      }, {
        name: 'coral',
        presentation: 'Coral',
        value: '#ED675A'
      }, {
        name: 'leopard',
        presentation: 'Leopard',
        image: File.open(File.join(Rails.root, 'app', 'assets', 'images', 'colours/leopard.png'))
      }, {
        name: 'floral',
        presentation: 'Floral',
        image: File.open(File.join(Rails.root, 'app', 'assets', 'images', 'colours/floral.png'))
      }, {
        name: 'fluoro-orange',
        presentation: 'Fluoro Orange',
        value: '#FF6903'
      }, {
        name: 'fluoro-yellow',
        presentation: 'Fluoro Yellow',
        value: '#F4FF02'
      }, {
        name: 'turquoise',
        presentation: 'Turquoise',
        value: '#41B5A8'
      }, {
        name: 'mint',
        presentation: 'Mint',
        value: '#7ED6C6'
      }, {
        name: 'sunset',
        presentation: 'Sunset',
        value: '#EDB32D'
      }, {
        name: 'pale-pink',
        presentation: 'Pale Pink',
        value: '#FCCDC5'
      }, {
        name: 'hot-pink',
        presentation: 'Hot Pink',
        value: '#F14873'
      }, {
        name: 'taupe',
        presentation: 'Taupe',
        value: '#b4a794'
      }, {
        name: 'grey',
        presentation: 'Grey',
        value: '#A3A7A8'
      }, {
        name: 'lilac',
        presentation: 'Lilac',
        value: '#BBA1CE'
      }, {
        name: 'mauve',
        presentation: 'Mauve',
        value: '#A68F97'
      }, {
        name: 'purple',
        presentation: 'Purple',
        value: '#421160'
      }, {
        name: 'aqua',
        presentation: 'Aqua',
        value: '#88C5CA'
      }, {
        name: 'ivory',
        presentation: 'Ivory',
        value: '#F1E4D3'
      }, {
        name: 'charcoal',
        presentation: 'Charcoal',
        value: '#343432'
      }, {
        name: 'royal-blue',
        presentation: 'Royal Blue',
        value: '#0E3299'
      }, {
        name: 'pale-blush',
        presentation: 'Pale Blush',
        value: '#E7CBC8'
      }, {
        name: 'pale-lavender',
        presentation: 'Pale Lavender',
        value: '#D5C5E9'
      }, {
        name: 'navy',
        presentation: 'Navy',
        value: '#00234B'
      }, {
        name: 'bronze',
        presentation: 'Bronze',
        value: '#9D6A4B'
      }, {
        name: 'sky-blue',
        presentation: 'Sky Blue',
        value: '#96C0E6'
      }, {
        name: 'cobalt-blue',
        presentation: 'Cobalt Blue',
        value: '#012D60'
      }, {
        name: 'fuchsia',
        presentation: 'Fuchsia',
        value: '#C74375'
      }, {
        name: 'canary-yellow',
        presentation: 'Canary Yellow',
        value: '#F6D400'
      }, {
        name: 'watermelon',
        presentation: 'Watermelon',
        value: '#E9658A'
      }, {
        name: 'emerald-green',
        presentation: 'Emerald Green',
        value: '#009875'
      }, {
        name: 'seafoam',
        presentation: 'Seafoam',
        value: '#BCE4DC'
      }, {
        name: 'pale-blue',
        presentation: 'Pale Blue',
        value: '#DDF1FA'
      }, {
        name: 'champagne',
        presentation: 'Champagne',
        value: '#F9E4CC'
      }, {
        name: 'gold',
        presentation: 'Gold',
        value: '#D6AE28'
      }, {
        name: 'nude',
        presentation: 'Nude',
        value: '#E7D0A6'
      }, {
        name: 'cream',
        presentation: 'Cream',
        value: '#EBE5CD'
      }
    ]

    option_values.each do |option_value|
      option_type.option_values.
        where(option_value.slice(:name)).
        first_or_create(option_value.slice(:presentation)).
        update_attributes(option_value.slice(:value, :image))
    end
  end

  task :similarities => :environment do
    Similarity.delete_all

    option_type = Spree::OptionType.color
    option_values = option_type.option_values.where(%q[value IS NOT NULL AND value != '']).to_a

    option_values.each_with_index do |original_option_value, index|
      original_color = Color::HEX.new(original_option_value.value).to_lab

      option_values.from(index + 1).each do |similar_option_value|
        similar_color = Color::HEX.new(similar_option_value.value).to_lab

        delta_e = Color::Base.delta_e_cie2000(original_color, similar_color)

        if delta_e < 30
          similarity = original_option_value.similarities.build
          similarity.similar = similar_option_value
          similarity.coefficient = delta_e
          similarity.save
        end
      end
    end
  end
end
