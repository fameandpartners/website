Spree::Product.class_eval do
  has_one :celebrity_inspiration,
    dependent: :destroy,
    class_name: 'Spree::CelebrityInspiration',
    foreign_key: :spree_product_id

  has_one :style_profile,
    dependent: :destroy,
    class_name: 'ProductStyleProfile',
    foreign_key: :product_id

  has_many :product_customisation_types
  has_many :customisation_types,
           through: :product_customisation_types
  has_many :product_customisation_values,
           through: :product_customisation_types
  has_many :product_color_values,
           dependent: :destroy

  scope :has_options, lambda { |option_type, value_ids|
    joins(variants: :option_values).where(
      "spree_option_values.id" => value_ids,
      "spree_option_values.option_type_id" => option_type.id
    )
  }


  accepts_nested_attributes_for :product_customisation_types,
    reject_if: lambda { |ct| ct[:customisation_type_id].blank? && ct[:id].blank? },
    allow_destroy: true
  attr_accessor :customisation_values_hash
  attr_accessible :featured, :customisation_values_hash, :product_customisation_types_attributes

  attr_accessible :zone_prices_hash
  attr_accessor :zone_prices_hash

  scope :featured, lambda { where(featured: true) }
  scope :ordered, lambda { order('position asc') }

  default_scope order: "#{self.table_name}.position"

  delegate_belongs_to :master, :in_sale?, :original_price, :price_without_discount

  before_create :set_default_prototype
  after_create :build_customisations_from_values_hash, :if => :customisation_values_hash

  before_save :update_price_conversions
  after_save :update_zone_prices, if: :zone_prices_hash

  def images
    table_name = Spree::Image.quoted_table_name

    Spree::Image.where(
      "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
      product_color_value_ids, variants_including_master_ids
    ).order('position ASC')
  end

  def images_for_variant(variant)
    table_name = Spree::Image.quoted_table_name

    Spree::Image.where(
      "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
      product_color_values.where(option_value_id: variant.option_value_ids).id, variant.id
    ).order('position ASC')
  end

  def remove_property(name)
    ActiveRecord::Base.transaction do
      property = Spree::Property.where(name: name).first
      return false if property.blank?

      Spree::ProductProperty.where(:product_id => self.id, :property_id => property.id).delete_all
      if Spree::ProductProperty.where(:property_id => property.id).count == 0
        property.destroy
      end
      true
    end
  end

  def video_url
    @video_url ||= begin
      video_id = self.property('video_id')
      # youtube
      # video_id.blank? ? '' : "//www.youtube.com/embed/#{video_id}?rel=0&showinfo=0"
      video_id.blank? ? '' : "http://player.vimeo.com/video/#{video_id}?title=0&byline=0&portrait=0&autoplay=0&loop=1"
    end
  end

  def colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        joins(:variants).
        where(spree_variants: {id: variant_ids}).uniq.map(&:name)
    else
      []
    end
  end

  def basic_colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        joins(:variants).
        where(spree_variants: {id: variant_ids}).uniq
    else
      []
    end
  end

  def custom_colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        where('spree_option_values.id NOT IN (?)', basic_colors.map(&:id)).uniq
    else
      []
    end
  end

  def description
    read_attribute(:description) || ''
  end

  def delete
    self.update_column(:deleted_at, Time.now)
    variants_including_master.update_all(:deleted_at => Time.now)
    update_index
  end

  def set_default_prototype
    self.prototype_id = self.class.default_prototype.try(:id)
  end

  def self.default_prototype
    Spree::Prototype.find_by_name('Dress')
  end

  def images_json
    color_type_id = option_types.find_by_name('dress-color').try(:id)
    size_type_id = option_types.find_by_name('dress-size').try(:id)
    images.map do |image|
      case image.viewable_type
      when 'Spree::Variant'
        color = image.viewable.option_values.detect { |ov| ov[:option_type_id] == color_type_id }.try(:name)
        size = image.viewable.option_values.detect { |ov| ov[:option_type_id] == size_type_id }.try(:name)
      when 'ProductColorValue'
        color = image.viewable.option_value.name
      end
      {
        large: image.attachment.url(:large),
        xlarge: image.attachment.url(:xlarge),
        small: image.attachment.url(:small),
        color: color,
        size: size
      }
    end
  end

  def zone_price_for(site_version = nil)
    if site_version.blank? or site_version.try(:default?)
      self.price_in(Spree::Config.currency)
    else
      self.master.zone_price_for(site_version)
    end
  end

  def update_price_conversions
    SiteVersion.where(default: false).each do |site_version|
      self.add_price_conversion(site_version.currency, site_version.exchange_rate)
    end
  end

  def add_price_conversion(new_currency, exchange_rate)
    return if new_currency == Spree::Config.currency

    default_price = self.price_in(Spree::Config.currency)
    price = prices.where(currency: new_currency).first_or_initialize
    price.variant_id ||= self.master.id
    price.amount = default_price.amount * exchange_rate
    price.save
  end

  def can_be_customized?
    product_customisation_values.present?
  end

  private

  def build_variants_from_option_values_hash
    ensure_option_types_exist_for_values_hash
    if prototype_id && prototype = Spree::Prototype.find_by_id(prototype_id)
      return unless sizes = prototype.option_types.find_by_name('dress-size').try(:option_values)

      colors = option_values_hash.values.first
      values = colors.product(sizes.map(&:id))

      values.each do |ids|
        variant = variants.create({
          :option_value_ids => ids,
          :price => master.price,
          :on_demand => true
        }, :without_protection => true)
      end
      save
    end
  end

  def build_customisations_from_values_hash
    customisation_values_hash.each do |type_id, value_ids|
      next unless type = CustomisationType.find_by_id(type_id)
      values = type.customisation_values.where(id: value_ids).map(&:id)
      next if values.empty?
      product_type = self.product_customisation_types.new
      product_type.customisation_type = type
      product_type.customisation_value_ids = values
    end
    save
  end

  def update_zone_prices
    self.master.update_zone_prices(self.zone_prices_hash)
  end
end
