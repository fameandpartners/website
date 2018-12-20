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
    product.product_color_values.find { |pcv| pid.include?(pcv.option_value.name) }
  end

  def color
    product_color_value&.option_value
  end

  def customizations
    JSON.parse(product.customizations).select { |c| pid.include?(c['customisation_value']['name']) }
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
