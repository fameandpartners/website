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

    def banner_image
      collection.details.banner.image
    end

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
