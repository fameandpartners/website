Spree::User.class_eval do
  has_one :profile_image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_many :wishlist_items, dependent: :destroy, class_name: "WishlistItem", foreign_key: :spree_user_id

  has_many :entries, class_name: 'CompetitionEntry'
  has_many :invitations, class_name: 'CompetitionInvitation'

  has_many :reservations, class_name: 'ProductReservation', foreign_key: :user_id

  has_one :personalization_settings

  attr_accessor :skip_welcome_email,
                :validate_presence_of_phone

  attr_accessible :phone

  validates :phone,
            presence: {
              if: :validate_presence_of_phone
            }

  after_create :synchronize_with_campaign_monitor!
  after_update :synchronize_with_campaign_monitor!,
               if: :campaign_monitor_should_be_updated?

  def update_profile(args = {})
    if args[:password].blank?
      args.delete(:password)
      args.delete(:password_confirmation)
    end

    update_attributes(args)
  end

  def update_profile_image(file)
    return if file.nil?
    image = self.profile_image || Spree::Image.new()
    image.viewable = self
    image.attachment = file
    image.save
  end

  def image(style = :small)
    img = self.profile_image
    if img.blank?
      return nil
    else
      img.attachment.url(style)
    end
  end

  def competition_entry
    self.entries.where(master: true).first
  end

  def reservation_for(product)
    self.reservations.where(product_id: product.id).first
  end

  def reservation_info(product = nil)
    info = { first_name: self.first_name, last_name: self.last_name }
    reservation = if product.present?
      self.reservations.where(product_id: product.id).first || self.reservations.first
    else
      self.reservations.first
    end
    if reservation.present?
      info.update({ school_name: reservation.school_name })
    end
    info
  end

  class << self
    def create_user(args)
      new_password = generate_password(12)
      user = Spree::User.new(
        first_name: args[:first_name],
        last_name: args[:last_name],
        email: args[:email],
        phone: args[:phone],
        password: new_password,
        password_confirmation: new_password
      )
      user.sign_up_reason = args[:sign_up_reason]
      user.validate_presence_of_phone = args[:validate_presence_of_phone]
      user.skip_welcome_email = true
      user.save

      user
    rescue
      user ||= Spree::User.new
    end

    def generate_password(length = 8)
      letters = (("a".."z").to_a + ('A'..'Z').to_a + (0..9).to_a)

      Array.new(length){|i| letters[rand(letters.count)]}.join
    end
  end

  def synchronize_with_campaign_monitor!
    CampaignMonitor.delay.synchronize(email_was || email, self, campaign_monitor_custom_fields)
  end

  def update_site_version(site_version)
    return false  if site_version.blank?
    return true   if self.site_version_id == site_version.id

    self.update_attribute(:site_version_id, site_version.id)
  end

  def recent_site_version
    SiteVersion.where(id: self.site_version_id) || SiteVersion.default
  end

  private

  def campaign_monitor_sign_up_reason
    self.class.campaign_monitor_sign_up_reason(sign_up_reason)
  end

  def self.campaign_monitor_sign_up_reason(code)
    case code
      when 'custom_dress' then
        'Custom dress'
      when 'style_quiz' then
        'Style quiz'
      when 'workshop' then
        'Workshop'
      when 'competition' then
        'Competition'
      when 'campaign_style_call' then
        'Campaign Style Call'
      when 'customise_dress' then
        'Customise dress'
      else
        nil
    end
  end

  def campaign_monitor_custom_fields
    custom_fields = {
      :Signupdate => created_at.to_date.to_s
    }

    if campaign_monitor_sign_up_reason.present?
      custom_fields[:Signupreason] = campaign_monitor_sign_up_reason
    end

    custom_fields
  end

  def campaign_monitor_should_be_updated?
    %w(email first_name last_name).any? do |attribute_name|
      changes.keys.include?(attribute_name)
    end
  end
end
