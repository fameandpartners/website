namespace "db" do
  namespace "populate" do
    desc "create products options"
    task :product_options => :environment do
      size_option = add_product_size_option
      color_option = add_product_color_option
      add_options_to_products(size_option, color_option)

      randomize_product_variants(size_option, color_option)
    end
  end
end

def add_product_size_option(force = false)
  args = {  name: 'dress-size', presentation: 'Size' }
  option_type = Spree::OptionType.where(args).first_or_create

  option_type.option_values.delete_all if force

  option_values = Array.new(5){|i| (8 + i * 2).to_s}
  build_option_values(option_type, option_values)

  option_type
end

def add_product_color_option(force = false)
  args = {  name: 'dress-color', presentation: 'Color' }
  option_type = Spree::OptionType.where(args).first_or_create

  option_type.option_values.delete_all if force

  option_values = %w{black red green blue pink gray yellow}
  build_option_values(option_type, option_values)

  option_type
end

def add_options_to_products(*options)
  Spree::Product.all.each do |product|
    product.option_types = options
  end
end

def randomize_product_variants(size_option, color_option)
  sizes   = size_option.option_values
  colors  = color_option.option_values

  Spree::Product.all.each do |product|
    product.variants.destroy_all
    random_sizes = get_random(sizes)
    random_colors = get_random(colors)

    random_sizes.each do |size_value|
      random_colors.each do |color_value|
        # black dresses of 8 size in stock only
        count_on_hand = size_value.name.to_s == '8' && color_value.to_s == 'black'
        variant = Spree::Variant.create(product_id: product.id)
        variant.option_values = [size_value, color_value]
      end
    end
  end
end

# private)
def build_option_values(option_type, values)
  values.each do |name, presentation|
    presentation ||= name.to_s.capitalize
    args = {name: name, presentation: presentation}
    value = option_type.option_values.where(args).first
    value ||= option_type.option_values.create(args)
  end
end

def get_random(args)
  length = rand(args.length)
  result = args.shuffle[0..length]
  result
end
