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
    { name: "dress-size", presentation: "Size" },
    { name: "dress-color", presentation: "Color"}
  ].each do |conditions|
    unless dress.option_types.where(conditions).exists?
      option_type = dress.option_types.where(conditions).first_or_create
      dress.option_types << option_type
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
