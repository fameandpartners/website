require 'geoip'

class UserCountryFromIP
  attr_reader :ip

  def initialize(ip)
    @ip = ip
  end

  def country_code
    begin
      if valid_ip?
        @country_code ||= geoip.country(ip).try(:country_code2)
      end
    rescue Exception => exception
      Rails.logger.warn(exception.message)
    end
  end

  def country_name
    begin
      if valid_ip?
        @country_code ||= geoip.country(ip).try(:country_name)
      end
    rescue Exception => exception
      Rails.logger.warn(exception.message)
    end
  end

  def country_code
    begin
      if valid_ip?
        @country_code ||= geoip.country(ip).try(:country_code2)
      end
    rescue Exception => exception
      Rails.logger.warn(exception.message)
    end
  end

  def valid_ip?
    ip.present? && ip != "127.0.0.1"
  end

  private

  def geoip
    @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
  end
end
