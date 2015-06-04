# usage
#   StyleQuiz::ProductsIndexer.new.index!
module StyleQuiz; end

class StyleQuiz::ProductsIndexer

  def initialize(options = {})
  end

  def index!
    index = build_index

    Spree::Product.where('tags is not null').each do |product|
      index.store(
        id: product.id,
        tags: product_tags_with_weight(product)
      )
    end
  end

  private

    def build_index
      #index = Tire.index(configatron.elasticsearch.indices.color_variants)
      index = Tire.index('style_quiz_products_profiles_index')
      index.delete
      index.create
      index
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
