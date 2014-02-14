namespace "db" do
  namespace "populate" do
    task styles: :environment do
      create_base_styles
    end
  end
end

def create_base_styles
  ProductStyleProfile::BASIC_STYLES.each do |style_name|
    style = Style.where(name: style_name).first_or_initialize
    style.save
  end
end
