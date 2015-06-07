# usage
#
#   service = StyleQuiz::ProductsRecommendations.new(style_profile: StyleQuiz::UserProfile.last)
#   service.read_all
#   service.product_score(product_id)
module StyleQuiz; end

class StyleQuiz::ProductsRecommendations
  attr_reader :style_profile

  def initialize(style_profile:)
    @style_profile = style_profile
  end

  def product_ids(limit: 8)
    product_ids_query(limit: limit).results.results.map(&:id)
  end

  def read_all(limit: 8)
    product_ids = product_ids(limit: 8)
    products_order = Hash[*product_ids.map.with_index{|x,i| [x.to_i, i]}.flatten]
    Spree::Product.where(id: product_ids).sort_by{|product| products_order[product.id]}
  end

  private

    def product_ids_query(limit:)
      script = relevance_calculations_script
      Tire.search('style_quiz_products_profiles_index', size: limit) do
        filter :exists, field: :id
        sort do
          by ({
            :_script => script.merge({
              type: 'number',
              order: 'desc'
            })
          })
        end
        from 0
        size limit
      end
    end

    def relevance_calculations_script
      {
        script: %q<
          result = 0;
          if (_source.containsKey('tags')) {
            foreach( product_tag : _source['tags'] ) {
              foreach ( profile_tag : profile_tags ){
                if (profile_tag.id == product_tag.id) {
                  result = result + profile_tag.weight * product_tag.weight
                }
              }
            }
          }
          return result;
        >.gsub(/[\r\n]|([\s]{2,})/, ''),
        params: { profile_tags: profile_tags }
      }
    end

    def profile_tags
      [].tap do |profile_tags|
        style_profile.tags.each do |tag_id, weight|
          profile_tags.push({ id: tag_id, weight: weight })
        end
      end
    end

    public

    # method to debug scores & relations
    def product_score(product_id)
      script = relevance_calculations_script
      Tire.search('style_quiz_products_profiles_index', size: 1) do
        filter :bool, :must => { :term => { :id => product_id }}

        script_field :relevance, script
      end.results.results.map(&:relevance).max
    end
end