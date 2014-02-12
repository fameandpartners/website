class Style < ActiveRecord::Base
  attr_accessible :name, :title, :accessories

  serialize :accessories, Array
  before_save :prepare_accessories

  validates :name, presence: true, inclusion: ProductStyleProfile::BASIC_STYLES

  has_many :images, class_name: 'StyleImage'

  def title
    super || "#{self.name.to_s.upcase} LOOK"
  end

  def accessories
    (super || []).map{|data| ActiveSupport::HashWithIndifferentAccess.new(data) }
  end

  def prepare_accessories
    new_values = []
    accessories.each do |item|
      if item['name'].present? || item['price'].present?
        new_values << item
      end
    end
    self.accessories = new_values
  end

  # returns 1 or 4 images
  def get_images
    stored_images = self.images.limit(4).to_a
    case stored_images.size
    when 0
      [self.images.new]
    when 1,4
      Array.wrap(stored_images)
    else
      Array.new(4) { |i| stored_images[i] || self.images.new(position: i) }
    end
  end

  class << self
    def get_all
      styles = Style.all.to_a
      ProductStyleProfile::BASIC_STYLES.map do |name|
        styles.find{|style| style.name == name} || new(name: name)
      end
    end

    def get_by_name(name)
      Style.where(name: name).first_or_initialize
    end
  end
end
