Spree::User.class_eval do
  has_one :profile_image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_many :wishlist_items, dependent: :destroy, class_name: "WishlistItem", foreign_key: :spree_user_id

  has_many :competition_entries, class_name: 'Competition::Entry'
  has_many :competition_invites, class_name: 'Competition::Invite'

  has_many :reservations, class_name: 'ProductReservation', foreign_key: :user_id

  has_one :personalization_settings

  has_many :bridesmaid_party_events, foreign_key: :spree_user_id, class_name: 'BridesmaidParty::Event', order: 'id desc'
  has_many :bridesmaid_party_members, foreign_key: :spree_user_id, class_name: 'BridesmaidParty::Member', order: 'id desc'

  has_many :email_notifications, foreign_key: :spree_user_id

  has_attached_file :avatar
  has_one :style_profile,
          :class_name => '::UserStyleProfile',
          :foreign_key => :user_id

  attr_accessor :skip_welcome_email,
                :validate_presence_of_phone

  attr_accessible :first_name, :last_name, :phone, :dob, :skip_welcome_email, :automagically_registered

  validates :first_name, :last_name, :presence => true

  validates :phone,
            presence: {
              if: :validate_presence_of_phone
            }

  after_create :send_welcome_email,           unless: Proc.new { |a| a.skip_welcome_email }
  after_create :create_marketing_subscriber,  if: :newsletter?
  after_update :update_marketing_subsriber,   if: :newsletter?

  def create_marketing_subscriber
    Marketing::Subscriber.new(user: self).create
  end

  def update_marketing_subsriber
    Marketing::Subscriber.new(user: self).update
  end

  def update_profile(args = {})
    if args[:password].blank?
      args.delete(:password)
      args.delete(:password_confirmation)
    end

    update_attributes(args)
  end

  def update_profile_image(file)
    return if file.nil?
    image = profile_image || build_profile_image
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

  def update_site_version(site_version)
    return false  if site_version.blank?
    return true   if self.site_version_id == site_version.id

    self.update_attribute(:site_version_id, site_version.id)
  end

  def recent_site_version
    SiteVersion.where(id: self.site_version_id).first || SiteVersion.default
  end

  # this logic should placed in bridesmaid module, without pollution user model
  def is_bride?
    bridesmaid_party_events.exists?
  end

  def can_receive_email_marketing_notification?(notification_code)
    case notification_code
    when 'wishlist_item_added', 'wishlist_item_added_reminder'
      self.is_bride? ? false : true
    else
      # may be we should check EmailNotification here
      true
    end
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def to_s
    "#{full_name} - #{email}"
  end

  def send_welcome_email
    tracker = Marketing::CustomerIOEventTracker.new
    tracker.identify_user(self, SiteVersion.find(self.site_version_id))
    tracker.track(
      self,
      'account_created',
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email
    )
  end
end
