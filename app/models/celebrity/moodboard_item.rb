class Celebrity::MoodboardItem < ActiveRecord::Base
  belongs_to :celebrity

  attr_accessible :celebrity_id, :image, :position, :active, :side

  # limit max width of images
  has_attached_file :image,
    styles: { product: "160", thumbnail: '80'},
    default_style: :product

  scope :right, where(side: 'right')
  scope :left, where('side != ?', 'right')

  default_scope order('side ASC, position ASC')
end
