## create elastic search index for search relevant products ids
# usage
#   StyleQuiz::ProductStyleProfileIndex.new(product).update
#   StyleQuiz::ProductStyleProfileIndex.update_all
#
module StyleQuiz; end

class StyleQuiz::ProductStyleProfileIndex
  attr_reader :product

  def initialize(product)
    @product = product
  end

  def update
    index.store(
      id: product.id,
      tags: product_tags_with_weight(product)
    )
  end

  def self.update_all
    # force index recreate
    Tire.index('style_quiz_products_profiles_index').delete
    Tire.index('style_quiz_products_profiles_index').create

    Spree::Product.where('tags is not null').each do |product|
      new(product).update
    end
  end

  private

    def index
      #index = Tire.index(configatron.elasticsearch.indices.color_variants)
      Tire.index('style_quiz_products_profiles_index')
    end

    def product_tags_with_weight(product)
      product.tags.map do |tag_id|
        tags_map[tag_id]
      end
    end

    # { id: { weight, name }}
    def tags_map
      @tags_map ||= begin
        tags = {}
        StyleQuiz::Tag.all.each do |tag|
          tags[tag.id] = { id: tag.id, weight: tag.weight }
        end
        tags
      end
    end
end
