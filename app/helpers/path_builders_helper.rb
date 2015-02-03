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
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?
    
    url_without_double_slashes(path)
  end

  # generate url for object/item
  #   name - id
  # previously was
  #   name - id - translated_short_description(locale)
  # NOTE: don't move it to model - 'item' not always Spree::Product [Tire::Results::Item or just Struct ]
  def descriptive_url(item)
    parts = [item.name.parameterize, item.id]
    parts.reject(&:blank?).join('-')
  end

  # /us/dresses/dress-eva-456?params
  def collection_product_path(product, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses']
    locale = I18n.locale.to_s.downcase.underscore.to_sym

    if product.is_a?(Tire::Results::Item) && product[:urls][locale].present?
      path_parts << "dress-#{product[:urls][locale]}"
    else
      path_parts << "dress-#{descriptive_url(product)}"
    end

    build_url(path_parts, options)
  end

  def collection_product_url(product, options = {})
    url_without_double_slashes(root_url(site_version: nil) + collection_product_path(product, options))
  end

  # /dresses/dress-eva-456/black?params
  def colored_variant_path(variant, options = {})
    parts = []
    parts << self.url_options[:site_version]
    parts << 'dresses'
   
    parts << "dress-#{variant.product[:urls][I18n.locale.to_s.downcase.underscore.to_sym]}"
    parts << variant.color.name

    build_url(parts, options)
  end

  # /dresses/styleit-eva-456
  def style_it_path(product, options={})
    path_parts = [
      self.url_options[:site_version],
      'dresses',
      "styleit-#{descriptive_url(product)}"
    ]
    build_url(path_parts, options)
  end

  # custom_collection_product_url('Long-Dresses', 'the-fallen', cf: 'homefeature')
  # "http://www.fameandpartners.com/collection/Long-Dresses/the-fallen?cf=homefeature" 
  def build_collection_product_path(collection_id, product_id, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'collection', collection_id, product_id]

    build_url(path_parts, options)
  end

  def build_collection_product_url(collection_id, product_id, options = {})
    url_without_double_slashes(
      root_url(site_version: nil) + build_collection_product_path(collection_id, product_id, options)
    )
  end

  # /dresses/long
  def build_taxon_path(taxon_name, options={})
    site_version_prefix = self.url_options[:site_version]

    #must downcase because we want case insensitive urls
    taxon = Spree::Taxon.where('lower(name) =?', taxon_name.downcase).last

    if taxon.nil?
      #check for non-hyphenated version of the taxon name
      taxon = Spree::Taxon.where('lower(name) = ?', taxon_name.downcase.gsub('-', ' ')).last
    end

    taxon_name = taxon.name.parameterize unless taxon.nil?

    path_parts = [site_version_prefix, 'dresses',taxon_name]

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
      url_without_double_slashes("#{ collection_product_path(item.product) }/#{ color.name }")
      path_parts = [collection_product_path(item.product), color.name]
      build_url(path_parts)
    else
      collection_product_path(item.product)
    end
  end

=begin
  # methods below not used. candidates to comment/throw away
  def make_url prefix, text
    "/#{prefix.join('/')}/#{text.downcase.gsub(/\s/, "_")}"
  end

  # /au/collection/taxon
  def collection_taxon_path(taxon)
    if range_taxonomy && range_taxonomy.taxons.where(id: taxon.id).exists?
      permalink = taxon.permalink.split('/').last
      site_version_prefix = self.url_options[:site_version]
      if site_version_prefix.present?
        "/#{site_version_prefix}/collection/#{permalink}".gsub(/\/+/, '/')
      else
        "/collection/#{permalink}"
      end
    else
      collection_path
    end
  end

  # /au/dresses/custom-dress-eva-456?params
  def personalize_path(product, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', "custom-#{descriptive_url(product)}" ]
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?    
    
    url_without_double_slashes(path)
  end

  def build_collection_taxon_path(collection, options = {})
    build_collection_product_path(collection, nil, options)
  end

  def taxon_path(taxon)
    site_version_prefix = self.url_options[:site_version]

    if site_version_prefix.present?
      result = "/#{site_version_prefix}/#{taxon.permalink}"
    else
      result = "/#{taxon.permalink}"
    end
    result.gsub(/\/+/, '/')
  end
=end
end
