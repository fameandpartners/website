module StyleQuiz
  class Seed
    def populate(options = {})
      puts "StyleQuiz::Seed. populate"
      #populate_tags
      #populate_questions
      #populate_answers
      populate_products
    end

    def populate_tags
      ['color.yml', 'pattern.yml', 'fabric.yml', 'style.yml', 'feature.yml', 'trend.yml'].each do |tags_file|
        path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', tags_file)
        YAML.load(File.read(path)).each do |tag_data|
          ::StyleQuiz::Tag.where(tag_data).first_or_create
        end
      end
    end

    def populate_questions
      path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', 'questions.yml')
      YAML.load(File.read(path)).each_with_index do |question_data, index|
        StyleQuiz::Question.where(code: question_data[:code]).first_or_create do |q|
          q.assign_attributes(question_data, without_protection: true)
          q.position = index
        end
      end
    end

    def populate_answers
      StyleQuiz::Question.all.each do |question|
        path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', "#{ question.code }-question-answers.yml")
        if FileTest.exists?(path)
          YAML.load(File.read(path)).each_with_index do |answer_data, index|
            question.answers.where(value: answer_data[:value].to_s).first_or_create do |answer|
              tag_names = answer_data.delete(:tags)
              answer.assign_attributes(answer_data, without_protection: true)
              answer.position = index
              answer.tags = get_tag_ids(tag_names)
              answer.active = true
            end
          end
        else
          puts "answers for question #{ question.name } not found or not required"
        end
      end
    end

    def populate_products
      serializer = ActiveRecord::Coders::YAMLColumn.new(Array)
      path = File.join(::StyleQuiz::Engine.root, 'db', 'seeds', 'products.yml')
      YAML.load(File.read(path)).each do |product_data|
        product = get_product(product_data[:sku], product_data[:name])
        next if product.blank?

        tags = get_tag_ids(product_data[:tags])

        product.update_column(:tags, serializer.dump(tags))
      end
    end

    def get_product(sku, name)
      name = name.downcase
      sku = sku.downcase
      variant = Spree::Variant.where('LOWER(TRIM(sku)) = ?', sku).first
      return variant.product if variant.present?

      product = Spree::Product.where('LOWER(TRIM(name)) = ?', name).first 
      return product if product.present?

      short_sku = sku.split('-').first.to_s
      variant = Spree::Variant.includes(:product).where("LOWER(TRIM(sku)) like '#{ short_sku }%'").first
      if variant && variant.product.name.match(/#{ name }/i)
        variant.product
      else
        nil 
      end 
    end

    def convert_tag_name_to_key(name)
      return 'some-default-key' if name.blank?
      name.to_s.downcase.parameterize
    end

    def tags_map
      @tags_map ||= begin
        result = {}
        StyleQuiz::Tag.all.each do |tag|
          result[convert_tag_name_to_key(tag.name)] = tag.id
        end
        result
      end
    end

    def get_tag_ids(tag_names = nil)
      return [] if tag_names.blank?

      tag_names.map do |name|
        tag = tags_map[convert_tag_name_to_key(name)]
        if tag.present?
          tag
        else
          puts "tag was not found #{ name }"
          nil
        end
      end.compact
    end
  end
end
