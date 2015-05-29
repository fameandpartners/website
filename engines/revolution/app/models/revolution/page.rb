module Revolution
  class Page < ActiveRecord::Base
    attr_accessible :path, :canonical, :parent, :parent_id, :template, :published

    validates :path, :presence => true
    validate :path_has_not_changed, :on => :update

    belongs_to :template
    has_many :translations

    acts_as_nested_set :counter_cache => :children_count

    def self.published
      where(:published => true)
    end

    def self.find_for(*paths)
      paths.each do |path|
        if page = published.find_by_path(path)
          return page
        end
      end
    end

    def template_path
      template.path
    end

    def path_has_not_changed
      if path_changed?
        errors.add(:path, 'path cannot be edited')
      end
    end
  end
end

# /dresses/summer
#   -> us translation
#   -> au translation
#
# /dresses/summer/red
#   parent -> /dresses/summer
