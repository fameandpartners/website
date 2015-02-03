# wrapper to taxon search
# NOTE - all taxons should be loaded inside each request only once and only if needed
# TODO - implement caching

module Repositories; end
class Repositories::Taxonomy
  class << self
    def get_taxon_by_name(taxon_name)
      taxon = Spree::Taxon.where('lower(name) =?', taxon_name.downcase).last

      # check for non-hyphenated version of the taxon name
      if taxon.nil?
        taxon = Spree::Taxon.where('lower(name) = ?', taxon_name.downcase.gsub('-', ' ')).last
      end

      taxon
    end

    # not implemented for now
    # have to reset @taxons each request
    # def taxons
    #   @taxons ||= Rails.cache.fetch(key, opts) do
    #     # load all taxons
    #   end
    # end
  end
end
