Spree::Product.class_eval do
  extend Spree::Product::CustomScopes

  has_one :celebrity_inspiration,
    dependent: :destroy,
    class_name: 'CelebrityInspiration',
    foreign_key: :spree_product_id, inverse_of: :product

  belongs_to :category

  has_one :style_profile,
    dependent: :destroy,
    class_name: 'ProductStyleProfile',
    foreign_key: :product_id

  has_many  :customisation_values,
            order: 'customisation_values.position ASC'
  
  has_many :customization_visualizations

  has_many :layer_cads,
           order: 'layer_cads.position ASC'
  has_many :product_color_values,
           dependent: :destroy, inverse_of: :product

  has_many :fabric_products,
           class_name: 'FabricsProduct',
           dependent: :destroy

  has_many :inspirations, foreign_key: :spree_product_id, inverse_of: :product
  has_many :accessories, class_name: 'ProductAccessory', foreign_key: :spree_product_id

  has_many :making_options, foreign_key: :product_id, class_name: 'ProductMakingOption'

  belongs_to :factory
  belongs_to :fabric_card, inverse_of: :spree_products

  has_and_belongs_to_many :related_outerwear,
                          association_foreign_key: :outerwear_id,
                          class_name: 'Spree::Product',
                          foreign_key: :product_id,
                          join_table: :spree_product_related_outerwear

  has_and_belongs_to_many :fabrics

  attr_accessible :customisation_value_ids,
                  :discounts_attributes,
                  :factory_id,
                  :fabric_card_id,
                  :featured,
                  :hidden,
                  :size_chart,
                  :related_outerwear_ids,
                  :category,
                  :fabric_id

  attr_reader :name_with_sku

  scope :has_options, lambda { |option_type, value_ids|
    joins(variants: :option_values).where(
      "spree_option_values.id" => value_ids,
      "spree_option_values.option_type_id" => option_type.id
    )
  }

  scope :not_hidden, lambda { where(hidden: false) }
  scope :outerwear, lambda { includes(taxons: :taxonomy).where(spree_taxonomies: { name: Spree::Taxonomy::OUTERWEAR_NAME }) }

  scope :featured, lambda { where(featured: true) }
  scope :ordered, lambda { order('position asc') }

  default_scope order: "#{self.table_name}.position"

  delegate_belongs_to :master, :in_sale?, :original_price

  before_create :set_default_prototype

  before_save :update_price_conversions

  after_initialize :set_default_values

  has_many :discounts, as: :discountable

  accepts_nested_attributes_for :discounts, reject_if: proc {|attrs| attrs[:amount].blank? }, allow_destroy: true

  accepts_nested_attributes_for :master
  attr_accessible :master_attributes

  SIZE_CHARTS = SizeChart::CHARTS.keys
  validates_inclusion_of :size_chart, in: SIZE_CHARTS

  def name_with_sku
    "#{name} (SKU: #{sku})"
  end

  def cache_key
    "products/#{id}-#{updated_at.to_s(:number)}"
  end

  def images
    table_name = Spree::Image.quoted_table_name

    # if self.fabrics.empty?
      prod_images = Spree::Image.where(
        "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
          OR
        (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
        product_color_value_ids, variants_including_master_ids
      ).order('position asc')
    # else
    #   prod_images = Spree::Image.where(
    #     "(#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))
    #       OR
    #     (#{table_name}.viewable_type = 'FabricsProduct' AND #{table_name}.viewable_id IN (?))",
    #     variants_including_master_ids, fabric_product_ids
    #   ).order('position asc')
    # end
    # prod_images
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

  def basic_color_ids
    product_color_values
      .active
      .recommended
      .pluck(:option_value_id)
  end

  def basic_fabric_ids
    fabric_products
      .recommended
      .pluck(:fabric_id)
  end

  def custom_fabric_ids
    fabric_products
      .custom
      .pluck(:fabric_id)
  end

  alias_method :color_ids, :basic_color_ids

  def basic_colors
    Spree::OptionValue.where(id: basic_color_ids)
  end

  def basic_fabrics
    Fabric.where(id: basic_fabric_ids)
  end

  def basic_fabrics_with_description
    fabrics_arry = []
    fabric_products.recommended.each do |fp|
        fabric_hsh = JSON.parse(fp.fabric.to_json, :symbolize_names => true) 
        fabric_hsh[:fabric][:price_usd] = '0' 
        fabric_hsh[:fabric][:price_aud] = '0' 
        fabric_hsh[:fabric][:description] = fp.description
        fabrics_arry << fabric_hsh
    end
    fabrics_arry
  end

  def custom_fabrics
    Fabric.where(id: custom_fabric_ids)
  end

  def custom_fabrics_with_description
    fabrics_arry = []
    fabric_products.custom.each do |fp|
        fabric_hsh = JSON.parse(fp.fabric.to_json, :symbolize_names => true) 
        fabric_hsh[:fabric][:description] = fp.description
        fabrics_arry << fabric_hsh
    end
    fabrics_arry
  end

  def color_names
    basic_colors.pluck(:name)
  end

  alias_method :colors, :color_names

  # TODO: Alexey Bobyrev - 04/Oct/2016
  # This method is unused.
  # We need to remove it or rewrite to use as `#active#custom` scope for
  # option_values from color_values
  def custom_colors
    option_types
      .color
      .option_values
        .where('spree_option_values.id NOT IN (?)', basic_color_ids)
        .uniq
  end

  def customisation_colors
    custom_colors.where(use_in_customisation: true)
  end

  def description
    read_attribute(:description) || ''
  end

  def short_description
    property('short_description') || ''
  end

  def default_standard_days_for_making
    5
  end

  def standard_days_for_making
    property("standard_days_for_making")
  end

  def default_customised_days_for_making
    10
  end

  def customised_days_for_making
    property("customised_days_for_making")
  end

  def color_customization
    DataCoercion.string_to_boolean(property('color_customization'))
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

  # NOTE: potentially dead code
  def images_json
    ::NewRelic::Agent.record_custom_event('spree_product_deprecated_images_json_method_called', product_id: self.id)

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

  def site_price_for(site_version = nil)
    self.master.site_price_for(site_version)
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
    customizations.present?
  end

  # Someday, a time of magic and sorcery, move this one and some another methods to decorator/presenter
  def delivery_time_as_string(format = :short)
    if fast_delivery
      I18n.t(format, scope: [:delivery_time, :fast])
    else
      I18n.t(format, scope: [:delivery_time, :standard])
    end
  end

  # TODO: this should be presenter logic, not model
  # at least single size-color can be fast delivered
  def fast_delivery
    @fast_delivery ||= self.variants.any?{|variant| variant.fast_delivery}
  end
  alias_method :fast_delivery?, :fast_delivery

  # TODO: this should be presenter logic, not model
  def fast_making
    @fast_making ||= self.making_options.fast_making.active.exists?
  end
  alias_method :fast_making?, :fast_making

  def active?
    ! deleted? && ! hidden? && available?
  end

  alias_method :is_active,  :active?
  alias_method :is_active?, :active?

  def discount
    @discount ||= Repositories::Discount.get_product_discount(self.id)
  end

  def plus_size?
    # NOTE: Alexey Bobyrev 31 Mar 2017
    # We need explicit check on nil value for memoization of false value
    if @plus_size.nil?
      @plus_size = taxons.where(name: 'Plus Size').exists?
    end
  end

  def jumpsuit?
    # NOTE: Alexey Bobyrev 31 Mar 2017
    # We need explicit check on nil value for memoization of false value
    if @jumpsuit.nil?
      @jumpsuit = taxons.where(name: 'Jumpsuit').exists?
    end
  end

  def height_customisable?
    ! jumpsuit?
  end

  def variant_skus
    variants.collect(&:sku)
  end

  def presenter_as_details_resource(site_version = nil)
    @product ||= Products::DetailsResource.new(
      site_version: site_version,
      product: self
    ).read
  end

  def delivery_period
    delivery_period_policy.delivery_period
  end

  def delivery_period_policy
    @delivery_period_policy ||= Policies::ProductDeliveryPeriodPolicy.new(self)
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

  def set_default_values
    if self.new_record?
      self.on_demand = true
      self.size_chart = SizeChart.default_chart_name
    end
  end

  # override spree core method
  def self.active(currency = nil)
    not_hidden.not_deleted.available(nil, currency)
  end

end
