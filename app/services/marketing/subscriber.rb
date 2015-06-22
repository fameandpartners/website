# usage:
#   Marketing::Subscriber.new(user: user)
#   Marketing::Subscriber.new(email: email)
#   Marketing::Subscriber.new(token: token) # create/update will be unavailable due to email absense
#
require 'geoip'

class Marketing::Subscriber
  attr_reader :user, :token, :email, :promocode, :campaign, :medium

  # @options [Hash]
  #  campaign - utm_campaign
  #  medium   - utm_medium
  def initialize(options = {})
    @user       = options[:user]
    @token      = options[:token]
    @email      = options[:email] || @user.try(:email) || @user.try(:email_was)
    @promocode  = options[:promocode]
    @campaign   = options[:campaign]
    @medium     = options[:medium]
    @ipaddress  = options[:ipaddress]
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
        campaign:  campaign || marketing_user_visit.utm_campaign,
        medium:    medium || marketing_user_visit.utm_medium,
        source:    marketing_user_visit.referrer,
        promocode: promocode,
        ipaddress: ipaddress,
        country:   country_name
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

    def ipaddress
      @ipaddress ||= user.present? ? user.last_sign_in_ip : nil
    end

    def country_name
      UserCountryFromIP.new(ipaddress).country_name
    end

end
