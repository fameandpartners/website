Spree::User.class_eval do
  attr_accessible :avatar
  has_attached_file :photo

  validates :first_name, :last_name, presence: true, if: :blog_moderator?
  validates_attachment_presence :avatar, if: :blog_moderator?

  private

  def blog_moderator?
    spree_roles.any? do |role|
      ['Blog Moderator', 'Blog Admin'].include?(role.name)
    end
  end
end
