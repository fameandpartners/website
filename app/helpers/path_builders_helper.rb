# encoding: utf-8
module PathBuildersHelper
  # products path generators should be placed here 
  #
  # doc:
  #   /dresses  -> dresses_pat
  #   /dresses/[taxon]  -> build_taxon_path('taxon_name_or_permalink')
  #

  def make_url prefix, text
    "/#{prefix.join('/')}/#{text.downcase.gsub(/\s/, "_")}"
  end

  # don't touch http:// or ftp://
  def url_without_double_slashes(url)
    # search elements with not colons and replace inside them
    url.gsub(/\w+(\/\/)/){|a| a.sub('//', '/')}
  end

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

  def descriptive_url(product, locale = nil)
    parts = []
    # this was how we had translated short descriptions as a part of the url
    # let's not delete it just yet, we might have to bring it back from the dead once again :)
    #parts << product.translated_short_description(locale || I18n.locale).parameterize
    parts << product.name.parameterize
    parts << product.id

    

    parts.reject(&:blank?).join('-')
  end

  def collection_product_path(product, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses']
    locale = I18n.locale.to_s.downcase.underscore.to_sym

    if product.is_a?(Tire::Results::Item) && product[:urls][locale].present?
      path_parts << "dress-#{product[:urls][locale]}"
    else
      path_parts << "dress-#{descriptive_url(product, locale)}"
    end

    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?
    
    url_without_double_slashes(path)
  end

  def colored_variant_path(variant, options = {})
    
    parts = []
    parts << self.url_options[:site_version]
    parts << 'dresses'
   
    parts << "dress-#{variant.product[:urls][I18n.locale.to_s.downcase.underscore.to_sym]}"
    parts << variant.color.name

    path =  '/' + parts.reject(&:blank?).join('/')
    path = "#{path}?#{options.to_param}" if options.present?

    url_without_double_slashes(path)
  end

  def personalize_path(product, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', "custom-#{descriptive_url(product)}" ]
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?    
    
    url_without_double_slashes(path)
  end

  def style_it_path(product, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', "styleit-#{descriptive_url(product)}" ]
    path =  "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?    
    
    url_without_double_slashes(path)
  end

  def collection_product_url(product, options = {})
    url_without_double_slashes(root_url(site_version: nil) + collection_product_path(product, options))
  end

  def build_collection_taxon_path(collection, options = {})
    build_collection_product_path(collection, nil, options)
  end

  # custom_collection_product_url('Long-Dresses', 'the-fallen', cf: 'homefeature')
  # "http://www.fameandpartners.com/collection/Long-Dresses/the-fallen?cf=homefeature" 
  def build_collection_product_path(collection_id, product_id, options = {})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'collection', collection_id, product_id]
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.present?

    url_without_double_slashes(path)
  end

  def build_collection_product_url(collection_id, product_id, options = {})
    url_without_double_slashes(
      root_url(site_version: nil) + build_collection_product_path(collection_id, product_id, options)
    )
  end


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
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.any?
    

    url_without_double_slashes(path)
  end

  def colour_path(color, options={})
    site_version_prefix = self.url_options[:site_version]
    path_parts = [site_version_prefix, 'dresses', color.downcase.parameterize]
    path = "/" + path_parts.compact.join('/')
    path = "#{path}?#{options.to_param}" if options.any?

    url_without_double_slashes(path)
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

end
