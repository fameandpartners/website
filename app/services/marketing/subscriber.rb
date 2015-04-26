# usage:
#   Marketing::Subscriber.new(user: user)
#   Marketing::Subscriber.new(email: email)
#   Marketing::Subscriber.new(token: token) # create/update will be unavailable due to email absense
#
require 'geoip'

class Marketing::Subscriber
  attr_reader :site_version, :user, :token, :email, :promocode, :campaign

  def initialize(options = {})
    @user       = options[:user]
    @token      = options[:token]
    @promocode  = options[:promocode]
    @ip_address = options[:ip_address]
    @email      = options[:email] || @user.try(:email) || @user.try(:email_was)
    @site_version = options[:site_version]
    @campaign  = options[:campaign]
    @sign_up_reason = options[:sign_up_reason]
  end

  def create
    validate!
    CampaignMonitor.schedule(:synchronize, email, user, custom_fields)
  end

  def update
    if user_changed?
      create
    end
  end

  def set_purchase_date(date = Date.today)
    CampaignMonitor.schedule(:set_purchase_date, user, date) if user.present?
  end

  def details
    HashWithIndifferentAccess.new(
      custom_fields.merge({
        email: email
      })
    )
  end

  private

    def user_changed?
      return false if user.blank?
      %w(email first_name last_name).any? do |attribute_name|
        user.changes.keys.include?(attribute_name)
      end
    end

    def validate!
      raise 'email required' if email.blank?
    end

    def custom_fields
      {
        campaign: campaign || marketing_user_visit.utm_campaign,
        referrer: marketing_user_visit.referrer,
        promocode: promocode,
        Signupdate: user.try(:created_at),
        Signupreason: sign_up_reason,
        site_version: preferred_site_version,
        ip_address: ip_address,
        country: country_name
      }
    end

    def marketing_user_visit
      @marketing_user_visit ||= begin
        if user.present?
          Marketing::UserVisit.where(spree_user_id: user.id).order('id desc').first_or_initialize
        elsif token.present?
          Marketing::UserVisit.where(user_token: token).order('id desc').first_or_initialize
        else
          Marketing::UserVisit.new
        end
      end
    end

    def ip_address
      @ip_address ||= user.present? ? user.last_sign_in_ip : nil
    end

    def country_name
      self.class.get_country(ip_address).try(:country_name)
    end

    def sign_up_reason
      @sign_up_reason ||= begin
        code = user.try(:sign_up_reason)
        self.class.sign_up_reasons[code.to_s] || code
      end
    end

    def preferred_site_version
      return site_version.code if site_version.present?
      user.present? ? user.recent_site_version.try(:name) : nil
    end

  public

  class << self
    def sign_up_reasons
      { 
        'custom_dress' => 'Custom dress',
        'style_quiz' => 'Style quiz',
        'workshop' => 'Workshop',
        'competition' => 'Competition',
        'campaign_style_call' => 'Campaign Style Call',
        'customise_dress' => 'Customise dress'
      }
    end

    def geoip
      @geoip ||= GeoIP.new(File.join(Rails.root, 'db', 'GeoIP.dat'))
    end

    def get_country(remote_ip)
      return nil if remote_ip.blank? || remote_ip == '127.0.0.1'
      geoip.country(remote_ip)
    rescue Exception => e
      nil
    end
  end
end
