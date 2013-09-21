namespace "db" do
  namespace "populate" do
    desc "create dress prototype with all properties"
    task prototypes: :environment do
      create_dress_prototype
    end
  end
end

def create_dress_prototype
  dress = Spree::Prototype.where(name: 'Dress').first_or_create

  add_dress_options(dress)
  add_dress_properties(dress)
end

def add_dress_options(dress)
  [
    { name: "dress-size", presentation: "Size", values: %w[6 8 10 12 14 16] },
    { name: "dress-color", presentation: "Color", values: %w[black red green blue pink gray yellow orange white blood-red jade-green peach silver tiffany-blue cherry-red hunter-green lime-green lemon ice-blue bright-orange bright-blue coral leopard floral fluoro-orange fluoro-yellow turquoise mint sunset pale-pink hot-pink taupe grey lilac mauve purple aqua ivory charcoal royal-blue pale-blush pale-lavender navy bronze sky-blue cobalt-blue fuchsia canary-yellow watermelon emerald-green seafoam pale-blue leopard floral champagne gold nude cream] }
  ].each do |conditions|
    option_values = Array.wrap(conditions.delete(:values))
    option_type = dress.option_types.where(conditions).first
    unless option_type.present?
      option_type = dress.option_types.where(conditions).first_or_create
      dress.option_types << option_type
    end
    (option_values - option_type.option_values.map(&:name)).each do |name|
      presentation = name.underscore.humanize.split.map(&:capitalize).join(' ')
      option_type.option_values << option_type.option_values.new({
        name: name,
        presentation: presentation
      })
    end
  end
end

def add_dress_properties(dress)
  properties = %w{short_description fit fabric weight inspiration inspiration_photo video_id}

  properties.each do |property_name|
    unless dress.properties.where(name: property_name).exists?
      property = Spree::Property.where(name: property_name).first_or_create
      dress.properties << property
    end
  end
end
