Spree::User.class_eval do
  has_one :profile_image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_many :wishlist_items, dependent: :destroy, class_name: "WishlistItem", foreign_key: :spree_user_id

  has_many :entries, class_name: 'CompetitionEntry'
  has_many :invitations, class_name: 'CompetitionInvitation'

  attr_accessor :skip_welcome_email

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

  class << self
    def create_user(name, email)
      new_password = generate_password(12)
      user = Spree::User.new(
        first_name: name,
        last_name: '',
        email: email,
        password: new_password,
        password_confirmation: new_password
      )
      user.skip_welcome_email = true
      if user.save(validate: false)
        ::Spree::UserMailer.welcome_to_competition(user).deliver
      end

      user
    rescue
      user ||= Spree::User.new
    end

    def generate_password(length = 8)
      letters = (("a".."z").to_a + ('A'..'Z').to_a + (0..9).to_a)

      Array.new(length){|i| letters[rand(letters.count)]}.join
    end
  end
end
