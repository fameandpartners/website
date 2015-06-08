require 'geoip'

class UserCountryFromIP
  attr_reader :ip

  def initialize(ip)
    @ip = ip
  end

  def country_code
    country.try(:country_code2)
  end

  def country_name
    country.try(:country_name)
  end

  def country
    @country ||= geoip.country(ip) if valid_ip?
  end

  def valid_ip?
    ip.present? && ip != "127.0.0.1" && IPAddress.valid?(ip)
  end

  private

  def geoip
    @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
  end
end
