Spree::Product.class_eval do
  has_one :celebrity_inspiration,
    dependent: :destroy,
    class_name: 'Spree::CelebrityInspiration',
    foreign_key: :spree_product_id

  has_one :style_profile,
    dependent: :destroy,
    class_name: 'ProductStyleProfile',
    foreign_key: :product_id

  scope :has_options, lambda { |option_type, value_ids|
    joins(variants: :option_values).where(
      "spree_option_values.id" => value_ids,
      "spree_option_values.option_type_id" => option_type.id
    )
  }

  attr_accessible :featured
  scope :featured, lambda { where(featured: true) }

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
      video_id = self.property('youtube_video_id') 
      video_id.blank? ? '' : "//www.youtube.com/embed/#{video_id}?rel=0&showinfo=0"
    end
  end

  def colors
    if option_type = option_types.find_by_name('dress-color')
      variants.map do |variant|
        variant.option_values.where(:option_type_id => option_type.id).map(&:name)
      end.flatten.uniq
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
end
