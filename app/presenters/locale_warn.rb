class LocaleWarn
  attr_reader :site_version

  def initialize(site_version)
    @site_version = site_version
    create_preferences
  end

  def flag_url
    "flags/bigger/#{version_code}.gif"
  end

  def button_text
    "Visit our #{version_code.upcase} Store"
  end

  def long_text_key
    "#{version_code}_locale_warn_text"
  end

  def long_text
    Spree::AppConfiguration.new[long_text_key]
  end

  private

  def create_preferences
    Spree::AppConfiguration.preference "#{version_code}_locale_warn_text" , :string, default: "Looks like you're in the :country. Visit our local store for :country_code sizes and :country_currency pricing."
  end

  def version_code
    site_version.code
  end
end
