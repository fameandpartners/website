Spree::User.class_eval do
  ALLOWED_AVATAR_FILE_TYPES = %w( image/jpg image/jpeg image/png image/gif )
  ALLOWED_AVATAR_FILE_SIZE = 0..1.megabytes
  SIGN_UP_REASON = %w( custom_dress style_quiz workshop competition campaign_style_call customise_dress)
  SIGN_UP_VIA = %w( Email Facebook )

  attr_accessible :avatar, :slug, :description, :newsletter, :dob
  has_attached_file :avatar, styles: { small: "160x160#"}

  #validates :first_name, :last_name, :slug, :description, presence: true, if: :blog_moderator?
  validates :slug, uniqueness: true, if: :blog_moderator?
  validates :sign_up_reason,
            :inclusion => {
              :allow_blank => true,
              :in => SIGN_UP_REASON
            }
  #validates_attachment_presence :avatar, if: :blog_moderator?
  validates_attachment_content_type :avatar, content_type: ALLOWED_AVATAR_FILE_TYPES
  validates_attachment_size :avatar, in: ALLOWED_AVATAR_FILE_SIZE

  before_validation :generate_slug

  has_many :posts, class_name: Blog::Post
  before_post_process :randomize_file_name

  def fullname
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  private

  def generate_slug
    if self.slug.blank?
      initial_slug = slug_from_name(fullname)
      new_slug = initial_slug
      index = 1
      while Spree::User.exists?(slug: new_slug)
        new_slug = "#{initial_slug}-#{index}"
        index += 1
      end
      self.slug = new_slug
    end
  end

  def slug_from_name(name)
    name.to_s.downcase.gsub(/[^0-9a-z]/, ' ').to_s.gsub(/\s+/, ' ').strip.gsub(' ', '-')
  end

  def blog_moderator?
    spree_roles.any? do |role|
      ['Blog Moderator', 'Blog Admin'].include?(role.name)
    end
  end


  private

  def randomize_file_name
    extension = File.extname(avatar_file_name).downcase
    self.avatar.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end

end
