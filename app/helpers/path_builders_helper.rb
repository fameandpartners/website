# encoding: utf-8
module PathBuildersHelper
  # products path generators should be placed here 
  #
  # active urls
  #   /dresses  -> dresses_path
  #   /dresses/[taxon]  -> build_taxon_path('taxon_name_or_permalink')
  #   /dresses/dress-eva-456?params -> collection_product_path(product, options = {})
  #   /dresses/dress-eva-456/black?params -> colored_variant_path(product, options = {})
  #   /dresses/styleit-eva-456  -> style_it_path(product, options)
  #   /dresses/red -> colour_path(color{name})
  #
  #
  # obsoleted urls:
  #   /collection/taxon => /dresses/taxon
  #     collection_taxon_path(collection)
  #
  #   /au/dresses/custom-dress-eva-456?params => /dresses/styleit-eva-456 
  #     personalize_path 
  #     personalization_style_product_path 
  #
  #   taxon_path


  # utils method - don't use anywhere else
  # don't touch http:// or ftp://
  def url_without_double_slashes(url)
    # search elements with not colons and replace inside them
    url.gsub(/\w+(\/\/)/){|a| a.sub('//', '/')}
  end

  # utils method - don't use anywhere else
  # [dresses, blue, { code: mode }] => /dresses/blue?code=mode
  def build_url(path_parts, options = {})
    path_parts.reject! { |el| el.blank? }
    path =  "/" + path_parts.join('/')
    path = "#{path}?#{options.to_param}" if options.present?
    
    url_without_double_slashes(path)
  end

  # generate url for object/item
  #   name - id
  # previously was
  #   name - id - translated_short_description(locale)
  # NOTE: don't move it to model - 'item' not always Spree::Product [Tire::Results::Item or just Struct ]
  def descriptive_url(item, locale = :en)
    parts = [item.name.parameterize, item.id]
    parts.reject(&:blank?).join('-')
  end

  # /us/dresses/dress-eva-456?params
  # product should be Tire::Results::Item ( color variant )
  # or respond to
  #  name - id
  def line_item_path(line_item_id, options = {})
    site_version_prefix = self.url_options[:site_version]
    
    "#{site_version_prefix}/sample-sale/#{line_item_id}"

  end

  def collection_product_path(product, options = {})
    site_version_prefix = self.url_options[:site_version]
    product_type        = options.delete(:product_type) || 'dress'
    path_parts          = [site_version_prefix, 'dresses']
    locale              = I18n.locale.to_s.downcase.underscore.to_sym

    if product.is_a?(Tire::Results::Item) && product[:urls][locale].present?
      path_parts << "#{product_type}-#{product[:urls][locale]}"
    else
      path_parts << "#{product_type}-#{descriptive_url(product)}"
    end

    # NOTE: Alexey Bobyrev 21/12/16
    # color method only present for Tire::Results::Item
    # But this method also called with ordinar spree product
    color_name = product.respond_to?(:color) && (product.color || {})[:name]

    if options[:color].nil? && color_name.present?
      options.merge!({ color: color_name })
    end

    build_url(path_parts, options)
  end

  def collection_product_url(product, options = {})
    url_without_double_slashes(root_url(site_version: nil) + collection_product_path(product, options))
  end

  # /dresses/dress-eva-456/black?params
  # TODO 02-12-2015 this method is not used anywhere. It's used by a legacy controller
  def colored_variant_path(variant, options = {})
    parts = []
    parts << self.url_options[:site_version]
    parts << 'dresses'

    parts << "dress-#{variant.product[:urls][I18n.locale.to_s.downcase.underscore.to_sym]}"
    parts << variant.color.name

    build_url(parts, options)
  end
  deprecate :colored_variant_path

  # TODO - Remove legacy URL
  # TODO 02-12-2015 this method is not used anywhere. It's used by a legacy controller
  # /dresses/styleit-eva-456
  def style_it_path(product, options={})
    path_parts = [
      self.url_options[:site_version],
      'dresses',
      "styleit-#{descriptive_url(product)}"
    ]
    build_url(path_parts, options)
  end
  deprecate :style_it_path

  # /dresses/long
  def build_taxon_path(taxon_name, options={})
    path_parts = [
      self.url_options[:site_version],
      'dresses'
    ]
    taxon = Repositories::Taxonomy.get_taxon_by_name(taxon_name)
    path_parts.push(taxon.permalink.parameterize) if taxon.present?

    build_url(path_parts, options)
  end

  # /dresses/red
  def colour_path(color, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', color.downcase.parameterize]

    build_url(path_parts, options)
  end

  # /dresses/dress-eva-456
  #   or
  # /dresses/dress-eva-456/color
  def wishlist_item_product_with_color_path(item)
    color = (item.color || item.variant.dress_color)
    if color.present?
      path_parts = [collection_product_path(item.product), color.name]
      build_url(path_parts)
    else
      collection_product_path(item.product)
    end
  end
end
