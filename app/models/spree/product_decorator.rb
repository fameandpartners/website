Spree::Product.class_eval do
  has_one :celebrity_inspiration,
    dependent: :destroy,
    class_name: 'Spree::CelebrityInspiration',
    foreign_key: :spree_product_id

  has_one :style_profile,
    dependent: :destroy,
    class_name: 'ProductStyleProfile',
    foreign_key: :product_id

  has_many  :customisation_values,
            order: 'customisation_values.position ASC'
  has_many :product_color_values,
           dependent: :destroy

  has_many :moodboard_items, foreign_key: :spree_product_id
  has_many :accessories, class_name: 'ProductAccessory', foreign_key: :spree_product_id
  has_many :videos, class_name: 'ProductVideo', foreign_key: :spree_product_id

  has_many :making_options, foreign_key: :product_id, class_name: 'ProductMakingOption'

  belongs_to :factory
  attr_accessible :customisation_value_ids,
                  :discounts_attributes,
                  :factory_id,
                  :featured,
                  :hidden,
                  :is_service,
                  :size_chart,
                  :zone_prices_hash


  scope :has_options, lambda { |option_type, value_ids|
    joins(variants: :option_values).where(
      "spree_option_values.id" => value_ids,
      "spree_option_values.option_type_id" => option_type.id
    )
  }

  scope :not_hidden, lambda { where(hidden: false) }

  has_many :zone_prices, :through => :variants, :order => 'spree_variants.position, spree_variants.id, currency'

  attr_accessor :zone_prices_hash

  scope :featured, lambda { where(featured: true) }
  scope :ordered, lambda { order('position asc') }

  default_scope order: "#{self.table_name}.position"

  delegate_belongs_to :master, :in_sale?, :original_price, :price_without_discount

  before_create :set_default_prototype

  before_save :update_price_conversions
  after_save :update_zone_prices, if: :zone_prices_hash

  after_initialize :set_default_values

  has_many :discounts, as: :discountable

  accepts_nested_attributes_for :discounts, reject_if: proc {|attrs| attrs[:amount].blank? }, allow_destroy: true

  SIZE_CHARTS = %w(2014 2015)
  validates_inclusion_of :size_chart, in: SIZE_CHARTS

  def new_size_chart?
    size_chart == SIZE_CHARTS.last
  end

  def cache_key
    "products/#{id}-#{updated_at.to_s(:number)}"
  end

  def service?
    is_service?
  end

  def free_shipping?
    is_service?
  end

  def images
    table_name = Spree::Image.quoted_table_name

    Spree::Image.where(
      "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
      product_color_value_ids, variants_including_master_ids
    ).order('position asc')
  end

  def images_for_colors(colors)
    table_name = Spree::Image.quoted_table_name
    color_ids = colors.map(&:id)
    viewables = product_color_values.where(option_value_id: color_ids)

    if viewables.present?
      whens = viewables.map do |viewable|
        "WHEN #{table_name}.viewable_id = #{viewable.id} THEN #{color_ids.index(viewable.option_value_id)}"
      end

      ordering_sql = "CASE #{whens.join(' ')} END ASC, position ASC"
    else
      ordering_sql = 'position ASC'
    end

    Spree::Image.
      where("#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?)", viewables.map(&:id)).
      order(ordering_sql)
  end

  def images_for_variant(variant)
    table_name = Spree::Image.quoted_table_name

    Spree::Image.where(
      "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
      product_color_values.where(option_value_id: variant.option_value_ids).map(&:id), variant.id
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
      videos = self.videos_json
      video = videos.find{|i| i[:default]} || videos.first
      video.present? ? video[:video_url] : video_url_from_property
   end
  end

  def videos_json
    @videos_json ||= self.videos.includes(:color).map do |product_video|
      {
        default: product_video.is_master?,
        color: (product_video.color.present? ? product_video.color.name : nil),
        video_url: product_video.video_url
      }
    end
  end

  def video_url_from_property
    video_id = self.property('video_id')
    return nil if video_id.blank?
    "http://player.vimeo.com/video/#{video_id}?title=0&byline=0&portrait=0&autoplay=0&loop=1"
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

  def color_ids
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        joins(:variants).
        where(spree_variants: {id: variant_ids}).uniq.map(&:id)
    else
      []
    end
  end

  def viewable_color_ids
    product_color_values.joins(:images).map(&:option_value_id)
  end

  # for case, when we trying to update indexes with no price [ in creating process]
  # TODO: it should be check in update index
  def price_for_search
    price.to_f
  rescue
    0.00
  end

  def basic_colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        joins(:variants).
        where(spree_variants: {id: variant_ids}).uniq
    else
      Spree::OptionValue.none
    end
  end

  def custom_colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        where('spree_option_values.id NOT IN (?)', basic_colors.map(&:id)).uniq
    else
      Spree::OptionValue.none
    end
  end

  def customisation_colors
    if option_type = option_types.find_by_name('dress-color')
      option_type.
        option_values.
        where(use_in_customisation: true).
        where('spree_option_values.id NOT IN (?)', basic_colors.map(&:id)).uniq
    else
      Spree::OptionValue.none
    end
  end

  def description
    read_attribute(:description) || ''
  end

  def short_description
    property('short_description') || ''
  end

  # properties have to be managed else where... two database requests for simple string?
  def color_customization
    property('color_customization').to_s.downcase == 'yes'
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
    images.map do |image|
      size = color = nil
      case image.viewable_type
      when 'Spree::Variant'
        color = image.viewable.dress_color.try(:name)
        size  = image.viewable.dress_size.try(:name)
      when 'ProductColorValue'
        color = image.viewable.option_value.name
      end
      {
        original: image.attachment.url(:original),
        large: image.attachment.url(:large),
        xlarge: image.attachment.url(:xlarge),
        small: image.attachment.url(:small),
        color: color,
        size: size
      }
    end
  end

  def zone_price_for(site_version = nil)
    if site_version.blank?
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
    customisation_values.present?
  end

  # Someday, a time of magic and sorcery, move this one and some another methods to decorator/presenter
  def delivery_time_as_string(format = :short)
    if fast_delivery
      I18n.t(format, scope: [:delivery_time, :fast])
    else
      I18n.t(format, scope: [:delivery_time, :standard])
    end
  end

  # at least single size-color can be fast delivered
  def fast_delivery
    return @fast_delivery if instance_variable_defined?('@fast_delivery')
    @fast_delivery = self.variants.any?{|variant| variant.fast_delivery}
  end
  alias_method :fast_delivery?, :fast_delivery

  def fast_making
    return @fast_making if instance_variable_defined?('@fast_making')
    @fast_making = self.making_options.fast_making.active.exists?
  end
  alias_method :fast_making?, :fast_making

  # TODO: implement more faster check
  # not deleted
  # available - check with date
  # have prices in default currency
  # have prices with non-null amount
  def is_active
    Spree::Product.is_active?(self.id)
  end
  alias_method :is_active?, :is_active

  def self.is_active?(product_id)
    @active_product_ids ||= begin
      Set.new(Spree::Product.active.pluck(:id))
    end
    @active_product_ids.include?(product_id)
  end

  def discount
    return @discount if instance_variable_defined?('@discount')
    @discount = Repositories::Discount.get_product_discount(self.id)
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

  def update_zone_prices
    self.variants_including_master.each do |variant|
      variant.update_zone_prices(self.zone_prices_hash)
    end
  end

  def set_default_values
    if self.new_record?
      self.on_demand = true
    end
  end

  # override spree core method
  def self.active(currency = nil)
    not_hidden.not_deleted.available(nil, currency)
  end
end
