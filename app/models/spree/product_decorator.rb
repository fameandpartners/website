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

  has_many :layer_cads,
           order: 'layer_cads.position ASC'
  has_many :product_color_values,
           dependent: :destroy, inverse_of: :product

  has_many :fabric_products,
           class_name: 'FabricsProduct',
           dependent: :destroy

  has_many :inspirations, foreign_key: :spree_product_id, inverse_of: :product
  has_many :accessories, class_name: 'ProductAccessory', foreign_key: :spree_product_id

  has_many :curations, class_name: 'Curation', foreign_key: :product_id

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

     if self.fabrics.empty?
      prod_images = Spree::Image.where(
        "(#{table_name}.viewable_type = 'ProductColorValue' AND #{table_name}.viewable_id IN (?))
          OR
        (#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))",
        product_color_value_ids, variants_including_master_ids
      ).order('position asc')
     else
      prod_images = Spree::Image.where(
        "(#{table_name}.viewable_type = 'Spree::Variant' AND #{table_name}.viewable_id IN (?))
          OR
        (#{table_name}.viewable_type = 'FabricsProduct' AND #{table_name}.viewable_id IN (?))",
        variants_including_master_ids, fabric_product_ids
      ).order('position asc')
    end
    prod_images
  end

  def basic_color_ids
    product_color_values
      .active
      .recommended
      .pluck(:option_value_id)
  end

  def basic_fabric_ids
    fabric_products
      .active
      .recommended
      .pluck(:fabric_id)
  end

  def custom_fabric_ids
    fabric_products
      .active
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

  def description
    read_attribute(:description) || ''
  end

  def short_description
    property('short_description') || ''
  end

  def standard_days_for_making
    property("standard_days_for_making")
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
  end

  def set_default_prototype
    self.prototype_id = self.class.default_prototype.try(:id)
  end

  def self.default_prototype
    Spree::Prototype.find_by_name('Dress')
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

  def active?
    ! deleted? && ! hidden? && available?
  end

  alias_method :is_active,  :active?
  alias_method :is_active?, :active?

  def discount
    @discount ||= discounts.active.first
  end

  def has_render?
    self.class.has_render?(self)
  end

  def is_new_product?
    self.class.is_new_product?(master.sku)
  end

  def self.has_render?(product)
    render_skus = ['FPG1001', 'FPG1002', 'FPG1003', 'FPG1004', 'FPG1005', 'FPG1006', 'SW']
    render_skus.include?(product.master.sku)
  end

  def self.use_new_pdp?(product_or_line_item)
    is_new_product?(product_or_line_item.sku)
  end

  def self.is_new_product?(product_id)
    product_id.downcase.starts_with?("fpg1") || product_id.downcase.starts_with?("sw")
  end

  def self.format_new_pid(sku, fabric, customizations)
    pid_components = self.format_new_pid_components(fabric, customizations);
    product_sku = sku

    return product_sku if pid_components.blank?
    
    "#{product_sku}~#{pid_components}"
  end

  def self.format_new_pid_components(fabric, customizations)
    should_split = fabric && /^\d+-\d+$/ =~ fabric

    components = [
      should_split ? fabric.split('-') : fabric,
      customizations.map{|c| c['customisation_value']['name']}
    ].flatten.compact.sort(&:casecmp).join("~")
  end

  def self.format_render_url(sku, fabric, customizations)
    "#{configatron.product_render_url}/#{sku}/FrontNone/704x704/#{Spree::Product.format_new_pid_components(fabric, customizations)}.png"
  end

  private

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
