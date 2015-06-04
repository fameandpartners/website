# usage
#
#   service = StyleQuiz::ProductsRecommendations.new(style_profile: StyleQuiz::UserProfile.last)
#   service.read_all
#
#   StyleQuiz::ProductsRecommendations.new(style_profile: StyleQuiz::UserProfile.last).read_all
#
module StyleQuiz; end

class StyleQuiz::ProductsRecommendations
  attr_reader :style_profile

  def initialize(style_profile:)
    @style_profile = style_profile
  end

  def read_all
    product_ids.results
  end

  private

    def product_ids(limit = 20)
      tag_ids = style_profile.tags.keys
      tag_weights = style_profile.tags.values
      results = Tire.search('style_quiz_products_profiles_index', size: limit) do
        filter :exists, field: :id
        sort do
          by ({
            :_script => {
              script: %q{
                return doc['id'];
              }.gsub(/[\r\n]|([\s]{2,})/, ''),
              params: {
                tag_ids: tag_ids,
                tag_weights: tag_weights
              },
              type: 'number',
              order: 'asc'
            }
          })
        end
        from 0
        size limit
      end
    end
end
=begin
# algorith
#
#
# profile.tags
# {11=>1, 61=>1, 98=>1, 130=>2, 176=>2, 5=>1, 123=>1, 114=>2, 71=>1, 49=>1, 4=>2, 47=>1, 75=>1, 138=>2, 135=>2, 18=>1}
#
