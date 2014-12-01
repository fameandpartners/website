module Search
  class Params
    def initialize(params)
      @params = params
    end

    def body_shapes
      ProductStyleProfile::BODY_SHAPES & Array(@params[:bodyshape].to_s.downcase)
    end

    def taxon_ids
      @taxon_ids ||= begin
        permalinks = []

        if @params[:style].present?
          permalinks << "style/#{@params[:style]}"
        end

        permalinks.map do |permalink|
          find_taxon_by_permalink(permalink).try(:id)
        end.compact
      end
    end

    private

    def taxons_by_permalink
      @@spree_taxons ||= begin
        Hash[*
          Spree::Taxon.all.map do |taxon|
            [taxon.permalink.downcase, taxon]
          end.flatten
        ]
      end
    end

    def find_taxon_by_permalink(permalink)
      taxons_by_permalink[permalink]
    end
  end
end