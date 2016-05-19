# /dresses/summer
#   -> us translation
#   -> au translation
#
# /dresses/summer/red
#   parent -> /dresses/summer

module Revolution
  class Page < ActiveRecord::Base

    attr_accessible :translations_attributes, :path, :template_path, :variables,
                    :canonical, :redirect, :parent, :parent_id, :nofollow, :noindex,
                    :publish_from, :publish_to, :product_order
    attr_accessor :params

    validates :path, :presence => true, :uniqueness => true
    validate :path_has_not_changed, :on => :update #read only attributes

    validates_inclusion_of :product_order, { allow_blank: true, in: Search::ColorVariantsQuery.product_orderings.keys }

    has_many :translations, dependent: :destroy, inverse_of: :page
    accepts_nested_attributes_for :translations, :reject_if => :all_blank

    acts_as_nested_set :counter_cache => :children_count

    serialize :variables, Hash

    delegate :title, :meta_description, :to => :translation, allow_nil: true

    attr_accessor :locale, :collection
    attr_readonly :path

    def heading
      (translation && translation.heading) || collection.details.banner.title
    end

    def sub_heading
      (translation && translation.sub_heading) || collection.details.banner.subtitle
    end

    def description
      if translation && translation.description
        @description ||= markdown? ? markdown.render(translation.description) : translation.description
      end
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

    ## Revolution banners
    def banner_image(position, size)
      ## NOTE: in future we may totally get rid of Taxons.  What happens if we do not have banners?
      ## Do we default to what?  '/dresses/...' has '/dresses/*', what about other types of pages?
      if banners_exist?(size)
        retrieve_banner(position, size).banner_url
      else
        collection.details.banner.image
      end
    end

    def no_of_banners(size)
      if banners_exist?(size)
        translations.banner_count(locale)
      else
        1
      end
    end

    def alt_text(position, size)
      if banners_exist?(size)
        retrieve_banner(position, size).alt_text
      else
        'alt_text'
      end
    end

    def retrieve_banner(position, size)
      #NOTE: If we ever go to more than 2 locales this will have to be changed.

      banners = get_default_banner(position, size, locale)
      if banners.blank?
        local_locale = translations.other_locale(locale)
        banners = get_default_banner(position, size, local_locale)
      end

      banners.first
    end

    def get_default_banner(position, size, local_locale)
      banners = translations.get_banner_for_pos(local_locale, position, size)
      if banners.blank?
        #If not found default to the first one
        banners = translations.get_banner_for_pos(local_locale, 0, size)
      end
      banners
    end

    def banners_exist?(size)
      banners_present = false
      translations.each do |translation|
        banners_present = translation.banner?(size)
        break if banners_present
      end
      banners_present
    end
    ## End Revolution banners
    
    def translation
      @translation ||= translations.find_for_locale(locale)
    end

    def get(key)
      variables[key] || variables[key.to_s]
    end

    def self.find_for(*paths)
      paths.each do |path|
        if page = published.find_by_path(path)
          return page
        end
      end
      nil
    end

    def self.published(n = nil)
      n ||= Time.now.utc
      where("? BETWEEN publish_from AND COALESCE(publish_to, ?)", n, n)
    end

    def published?(n = nil)
      n ||= Time.now.utc
      (publish_from.present? && n >= publish_from) && (publish_to.blank? || n < publish_to)
    end

    def publish!(publish_date = nil)
      publish_date ||= Time.now.utc
      update_attributes!(:publish_from => publish_date)
    end

    def redirect?
      redirect.present?
    end

    def canonical_path
      canonical || path
    end

    def path_has_not_changed
      if path_changed?
        errors.add(:path, 'path cannot be edited')
      end
    end

    def self.paging(page, per_page)
      order('path ASC').page(page).per(per_page)
    end

    def self.for_path(query)
      where("LOWER(path) like '%#{query.downcase}%'")
    end

    def limit(product_ids)
      return self.get(:limit) || 20 if page_is_lookbook?

      page_limit     = effective_page_limit
      base_offset    = params[:offset].to_i
      total_offset   = base_offset + page_limit
      no_of_products = Array.wrap(product_ids).size

      if no_of_products < total_offset
        products_on_page = no_of_products - base_offset
        page_limit - [products_on_page, 0].max
      else
        0
      end
    end

    def offset(product_ids, offset)
      offset       = offset.to_i
      product_size = Array.wrap(product_ids).size

      [0, offset - product_size].max
    end

    def page_is_lookbook?
      self && self.get(:lookbook)
    end

    def markdown?
      self && self.get(:markdown)
    end


    def effective_page_limit
      (params[:limit] || self.get(:limit) || default_page_limit).to_i
    end

    def default_page_limit
      21
    end

    def self.default_page
      Revolution::Page.new(template_path: '/products/collections/show')
    end

    def robots
      [].tap do |a|
        a << (noindex? ? 'noindex' : 'index')
        a << (nofollow? ? 'nofollow' : 'follow')
      end.join(',')
    end

  end
end
