class LocaleWarn
  attr_reader :ip, :current_site_version, :session_site_version_code

  def initialize(opts = {})
    @ip                        = opts[:ip]
    @current_site_version      = opts[:current_site_version]
    @session_site_version_code = opts[:session_site_version_code]

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

  # - Warning will show when:
  # -> User is from country that differs from current site version
  # -> User did not choose any the site version
  # -> User hasn't closed the alert
  def show?
    session_site_version_code.nil? && current_site_version != positional_site_version
  end

  private

  def positional_site_version
    FindUsersSiteVersion.new(request_ip: ip).sv_chosen_by_ip || SiteVersion.default
  end

  def version_code
    positional_site_version.code
  end

  def create_preferences
    Spree::AppConfiguration.preference "#{version_code}_locale_warn_text" , :string, default: "Looks like you're in the :country. Visit our local store for :country_code sizes and :country_currency pricing."
  end
end
