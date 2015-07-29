class FindUsersSiteVersion
  attr_reader :user, :url_param, :cookie_param, :request_ip

  def initialize(options = {})
    @user         = options[:user]
    @url_param    = options[:url_param]
    @cookie_param = options[:cookie_param]
    @request_ip   = options[:request_ip]
  end

  def get
    sv_chosen_by_user || sv_chosen_by_cookie || sv_chosen_by_location || sv_chosen_by_param || default_site_version
  end

  private

  def sv_chosen_by_user
    if user && user.site_version_id.present?
      SiteVersion.find_by_id(user.site_version_id)
    end
  end

  def sv_chosen_by_cookie
    if cookie_param.present?
      find_by_permalink(cookie_param)
    end
  end

  def sv_chosen_by_location
    if request_ip.present?
      if country = fetch_user_country_code
        find_by_permalink(country.to_s.downcase)
      end
    end
  end

  def sv_chosen_by_param
    if url_param.present?
      find_by_permalink(url_param)
    end
  end

  def fetch_user_country_code
    UserCountryFromIP.new(request_ip).country_code
  end

  def default_site_version
    SiteVersion.default
  end

  def find_by_permalink(permalink)
    SiteVersion.find_by_permalink(permalink)
  end
end
