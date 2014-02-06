class Style < ActiveRecord::Base
  attr_accessible :name, :title, :accessories

  serialize :accessories, Array
  before_save :prepare_accessories

  validates :name, presence: true, inclusion: ProductStyleProfile::BASIC_STYLES

  has_attached_file :image,
    styles: { product: "375x480#", thumbnail: "187x240#" },
    default_style: :product,
    default_url:   :default_image_for_style

  def default_image_for_style
    '/assets/_sample/category-grey-2.jpg'
  end

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
