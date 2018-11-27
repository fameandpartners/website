require_dependency 'spree/taxonomy_decorator'

Spree::Taxon.class_eval do
  include Concerns::Publishable
  
  FILTER_TAXON_PERMALINKS = ["style/halter", "style/strapless", "style/off-shoulder", "style/split", "style/sequin", "style/a-line", "style/bodycon", "style/fit-and-flare"]

  scope :filterable, -> { where(permalink: FILTER_TAXON_PERMALINKS)}

  class << self
    def find_child_taxons_by_permalink(permalink)
      where('permalink LIKE ?', "%/#{permalink.downcase}").first
    end

    def from_taxonomy(taxonomy_name)
      includes(:taxonomy).where(spree_taxonomies: { name: taxonomy_name })
    end

    ::Spree::Taxonomy::CURRENT.each do |taxonomy_name|
      define_method("from_#{taxonomy_name.downcase}_taxonomy") do
        from_taxonomy(taxonomy_name)
      end
    end
  end

  def seo_title
    return meta_title if !meta_title.blank?
    name
  end
end
