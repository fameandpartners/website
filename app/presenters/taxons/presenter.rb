module Taxons
  class Presenter
    extend Forwardable

    attr_reader :taxon

    def_delegators :taxon, :permalink

    def initialize(spree_taxon:)
      @taxon = spree_taxon
    end
  end
end
