# /dresses/summer
#   -> us translation
#   -> au translation
#
# /dresses/summer/red
#   parent -> /dresses/summer

module Revolution
  class Page < ActiveRecord::Base
    attr_accessible :path, :template_path, :canonical, :redirect, :parent, :parent_id, :publish_from, :publish_to, :variables

    validates :path, :presence => true
    validate :path_has_not_changed, :on => :update #read only attributes

    has_many :translations

    acts_as_nested_set :counter_cache => :children_count

    serialize :variables

    delegate :title, :meta_description, :heading, :sub_heading, :description, :to => :translation

    after_initialize :set_defaults

    attr_accessor :locale

    def set_defaults
      self.variables ||= {}
    end

    def translation
      @translation ||= translations.find_for_locale(locale)
    end

    def get(key)
      variables[key]
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
  end
end
