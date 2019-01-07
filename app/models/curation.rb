class Curation < ActiveRecord::Base
  attr_accessible :product, :product_id, :pid, :images

  belongs_to :product, class_name: 'Spree::Product'
  has_many :images, as: :viewable, order: :position, class_name: "Spree::Image"
  has_and_belongs_to_many :taxons, class_name: "Spree::Taxon"

  default_scope include: [:images]
  scope :active, where(active: true)

  validates :product,
            :presence => true

  validates :pid,
            :presence => true

  def discount_price_in(currency)
    product_price = product.discount_price_in(currency)

    fabric_price = 0

    if fabric_product
      fabric_price = fabric_product.discount_price_in(currency)
    elsif product_color_value
      fabric_price = product_color_value&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
    end

    customizations_price = customizations.map{ |c| c.discount_price_in(currency) }.sum

    product_price.amount.to_f + fabric_price + customizations_price
  end

  def price_in(currency)
    product_price = product.price_in(currency)

    fabric_price = 0

    if fabric_product
      fabric_price = fabric_product.price_in(currency)
    elsif product_color_value
      fabric_price = product_color_value&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
    end

    customizations_price = customizations.map{ |c| c.price_in(currency) }.sum

    product_price.amount.to_f+ fabric_price + customizations_price
  end


  def fabric_product
    pid_components = pid.split('~')

    product.fabric_products.find do |fp| 
      should_split = /^\d+-\d+$/ =~ fp.fabric.name
      fabric_components = should_split ? fp.fabric.name.split('-') : [fp.fabric.name]

      fabric_components.all? {|c| pid_components.include?(c) }
    end
  end

  def fabric
    fabric_product&.fabric
  end

  def product_color_value
    pid_components = pid.split('~')

    product.product_color_values.find { |pcv| pid_components.include?(pcv.option_value.name) }
  end

  def color
    product_color_value&.option_value
  end

  def customizations
    pid_components = pid.split('~')

    product.customisation_values.select { |c| pid_components.include?(c.name) }
  end

  def cropped_images
    cropped_images = images.select { |i| i.attachment_file_name.to_s.downcase.include?('crop') }

    if cropped_images.empty?
      cropped_images = images.select { |i| i.attachment_file_name.to_s.downcase.include?('front') }
    end

    if cropped_images.empty?
      cropped_images = images
    end

    cropped_images
  end
end
