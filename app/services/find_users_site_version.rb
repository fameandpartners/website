class FindUsersSiteVersion
  attr_reader :user, :url_param, :cookie_param, :request_ip

  def initialize(options = {})
    @user         = options[:user]
    @url_param    = options[:url_param]
    @cookie_param = options[:cookie_param]
    @request_ip   = options[:request_ip]
  end

  def get
    sv_chosen_by_user || sv_chosen_by_cookie || sv_chosen_by_location || sv_chosen_by_param || SiteVersion.default
  end

  private

  def sv_chosen_by_user
    if user && user.site_version_id.present?
      SiteVersion.find_by_id(user.site_version_id)
    end
  end

  def sv_chosen_by_cookie
    if cookie_param.present?
      SiteVersion.find_by_permalink(cookie_param)
    end
  end

  def sv_chosen_by_location
    version_permalink = fetch_user_country_code
    site_version = SiteVersion.find_by_permalink(version_permalink)

    site_version
  end

  def sv_chosen_by_param
    if url_param.present?
      SiteVersion.find_by_permalink(url_param)
    end
  end

  def fetch_user_country_code
    begin
      require 'geoip'
      geoip = GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
      remote_ip = request_ip
      country_code = 'us'
      if remote_ip != "127.0.0.1"
        country_code = geoip.country(request_ip).try(:country_code2)
      end
      country_code.downcase
    rescue Exception => exception
      Rails.logger.warn(exception.message)
      'us'
    end
  end
end
