Spree::User.class_eval do
  has_one :profile_image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_many :wishlist_items, dependent: :destroy, class_name: "WishlistItem", foreign_key: :spree_user_id

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
      return ''
    else
      img.attachment.url(style)
    end
  end
end
