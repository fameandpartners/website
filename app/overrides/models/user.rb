Spree::User.class_eval do
  ALLOWED_AVATAR_FILE_TYPES = %w( image/jpg image/jpeg image/png image/gif )
  ALLOWED_AVATAR_FILE_SIZE = 0..1.megabytes
  SIGN_UP_REASON = %w( custom_dress style_quiz workshop competition campaign_style_call customise_dress bridesmaid_party )
  SIGN_UP_VIA = %w( Email Facebook )

  attr_accessible :avatar, :newsletter, :dob, :site_version_id
  has_attached_file :avatar, styles: { small: "160x160#"}

  validates :sign_up_reason,
            :inclusion => {
              :allow_blank => true,
              :in => SIGN_UP_REASON
            }
  validates_attachment_content_type :avatar, content_type: ALLOWED_AVATAR_FILE_TYPES
  validates_attachment_size :avatar, in: ALLOWED_AVATAR_FILE_SIZE

  before_post_process :randomize_file_name

   before_save :downcase_email

  def fullname
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def downcase_email
    self.email = self.email.downcase
  end

  private

  def randomize_file_name
    extension = File.extname(avatar_file_name).downcase
    self.avatar.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end
end
