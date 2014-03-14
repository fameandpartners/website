class Blog::PostPhoto < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  attr_writer     :primary
  attr_accessible :photo, :primary

  belongs_to :post, class_name: Blog::Post, counter_cache: true
  belongs_to :user, class_name: Spree::User

  #has_attached_file :photo, styles: { preview: "742x355#"}
  has_attached_file :photo, 
    default_style: 'post',
    styles: { 
      banner_small: '460x360#',
      banner: '1140x400#',
      preview: '745x261#',
      post: '373x230#',
      thumbnail: '239x147#'
    }

  validates_attachment_presence :photo
  validates :user_id, presence: true

  def primary
    self.persisted? && post.primary_photo_id == self.id
  end

  def primary_text
    primary ? 'yes' : 'no'
  end

  def to_jq_upload
    {
      "name" => read_attribute(:photo_file_name),
      "size" => read_attribute(:photo_file_size),
      "thumbnail_url" => photo.url,
      "url" => photo.url,
      "id" => self.id,
      "delete_url" => "/admin/blog/post_photos/#{self.id}",
      "delete_type" => "DELETE"
    }
  end

end
