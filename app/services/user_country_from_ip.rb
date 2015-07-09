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
    return nil unless valid_ip?

    @country ||= begin
      ip_address = IPAddress.parse(ip)
      if ip_address.ipv4?
        geoip.country(ip)
      elsif ip_address.ipv6?
        geoip6.country(ip)
      else
        nil
      end
    end
  end

  def valid_ip?
    ip.present? && ip != "127.0.0.1" && IPAddress.valid?(ip)
  end

  private

  def geoip
    @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
  end

  def geoip6
    @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'GeoIPv6.dat'))
  end
end
