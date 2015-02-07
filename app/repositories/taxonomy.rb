# wrapper to taxon search
# NOTE - all taxons should be loaded inside each request only once and only if needed
# TODO - implement caching

module Repositories; end
class Repositories::Taxonomy
  class << self
    def get_taxon_by_name(taxon_name)
      taxon_name = taxon_name.downcase
      taxon = taxons.find{|t| t.name.downcase == taxon_name }

      if taxon.nil? && taxon_name.match(/-/)
        taxon_name = taxon_name.gsub('-', ' ')
        taxon = taxons.find{|t| t.name.downcase == taxon_name }
      end

      taxon
    end

    def read_styles
      taxons.select{|taxon| taxon.taxonomy == 'Style'}
    end

    def read_events
      taxons.select{|taxon| taxon.taxonomy == 'Event'}
    end

    def taxons
      read_all
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

    def expire_cache!(force)
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

      Spree::Taxon.includes(:taxonomy, :banner).each do |taxon|
        result = OpenStruct.new(
          { 
            id: taxon.id,
            taxonomy: taxon.taxonomy.name,
            name: taxon.name,
            permalink: taxon.base_permalink,
            position: taxon.position,
            meta_title: taxon.meta_title,
            meta_description: taxon.meta_description,
            meta_keywords: taxon.meta_keywords,
            banner: OpenStruct.new({})
          }
        )
        if taxon.banner.present?
          result.banner.title       = taxon.banner.title
          result.banner.description = taxon.banner.description
          result.banner.image       = taxon.banner.image(:url)
        end

        if !taxon.root?
          all_taxons.push(result)
        end
      end

      all_taxons.sort_by{|i| i.position}
    end
  end
end
