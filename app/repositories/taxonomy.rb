# wrapper to taxon search
# all taxons should be loaded inside each request only once and only if needed
#
# external api:
# Repositories::Taxonomy.get_taxon_by_name('code')
# Repositories::Taxonomy.read_styles
# Repositories::Taxonomy.read_events
# Repositories::Taxonomy.read_collections
# Repositories::Taxonomy.read_all

module Repositories; end
class Repositories::Taxonomy
  class << self
    FILTER_TAXON_PERMALINKS = ["halter", "strapless", "off-shoulder", "split", "sequin", "a-line", "bodycon", "fit-and-flare"]
    
    def get_taxon_by_name(taxon_name)
      result = Array.wrap(taxon_name).compact.map do |tn|
        taxons.find { |t| t.name.parameterize == tn.parameterize }
      end
      result.size < 2 ? result.first : result
    end

    def collect_filterable_taxons
      read_styles.select {|taxon| FILTER_TAXON_PERMALINKS.index( taxon.permalink ).present? }
    end
    
    def collection_root_taxon
      taxons.select{|taxon| taxon.taxonomy == 'Range' && taxon.root }.first
    end

    def read_styles
      taxons.select{|taxon| taxon.taxonomy == 'Style' && !taxon.root }.sort_by{ |t| t.name }
    end

    def read_events
      taxons.select{|taxon| taxon.taxonomy == 'Event' && !taxon.root }.sort_by{ |t| t.name }
    end

    def read_collections
      taxons.select{|taxon| taxon.taxonomy == 'Range' && !taxon.root }.sort_by{ |t| t.name }
    end

    def taxons
      read_all.clone
    end

    # utils methods
    #   - if force, then reset @taxons and rails.cache
    #   - if @taxons loaded too early, reset only it
    #   - read
    def read_all(options = {})
      expire_cache!(options[:force])
      @taxons ||= Rails.cache.fetch(cache_key, expires_in: cache_expires_in) { load_all_taxons }
    end

    def cache_key
      'application-taxonomy'
    end

    def cache_expires_in
      configatron.cache.expire.long
    end

    # we don't have any mechanism to reset class variables through all instances
    # keep this value small - single request to redis per request works too
    def class_variables_expires_in
      configatron.cache.expire.quickly
    end

    def expire_cache!(force = false)
      if force
        @taxons = nil
        Rails.cache.delete(cache_key)
      elsif @taxons_loaded_at.blank? || @taxons_loaded_at < class_variables_expires_in.seconds.ago
        @taxons = nil
      end
    end

    #private

    def load_all_taxons
      @taxons_loaded_at = Time.now
      all_taxons = []

      # NOTE: Alexey Bobyrev 13 Jan 2017
      # We should avoid calling relations here as they could be `nil`
      # Temporary solution is to add safe navigator
      # Which is obviously need to be handled properly
      Spree::Taxon.includes(:taxonomy, :banner).each do |taxon|
        result = OpenStruct.new(
          {
            id: taxon.id,
            taxonomy: taxon.taxonomy&.name,
            name: taxon.name,
            permalink: taxon.base_permalink,
            position: taxon.position,
            meta_title: taxon.seo_title,
            title: taxon.seo_title,
            meta_description: taxon.meta_description,
            meta_keywords: taxon.meta_keywords,
            description: taxon.description,
            banner: OpenStruct.new({}),
            root: taxon.root?
          }
        )

        if taxon.banner.present?
          result.banner.title       = taxon.banner.title
          result.banner.subtitle    = taxon.banner.description
          result.banner.image       = taxon.banner.image.present? ? taxon.banner.image(:banner) : nil
          result.footer             = taxon.banner.footer_text
          result.seo_description    = taxon.banner.seo_description
        end
        all_taxons.push(result)
      end

      all_taxons.sort_by{|i| i.position}
    end
  end
end
