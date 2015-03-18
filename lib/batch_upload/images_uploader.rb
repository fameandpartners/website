module BatchUpload
  class ImagesUploader
    def initialize(location, strategy = :update)
      @_strategies = [:update, :delete]
      @_expiration = 6.hours

      @_location = location
      unless @_strategies.include?(strategy)
        raise "Undefined strategy name! Select between #{@_strategies.to_sentence}"
      else
        @_strategy = strategy
      end
    end

    private

    def each_product &block
      get_list_of_directories(@_location).each do |path|
        puts ""
        name = path.rpartition('/').last.strip

        puts "[INFO] Process \"#{name}\" directory"
        puts "[INFO] Parse directory name"

        matches = Regexp.new('(?<sku>[[:alnum:]]+)[\-_]?', true).match(name)

        if matches.blank?
          puts "[ERROR] Directory name is invalid"
          next
        else
          puts "[INFO] Directory name successfully parsed"
          sku = matches[:sku].downcase.strip
          puts "  SKU: #{sku}"
        end

        puts "[INFO] Search product by SKU"

        product = Spree::Variant.
          where(deleted_at: nil, is_master: true).
          where('LOWER(TRIM(sku)) = ?', sku).
          order('id DESC').first.try(:product)

        if product.blank?
          puts "[ERROR] Product not found"
          next
        else
          puts "[INFO] Product successfully found"
          puts "  ID:   #{product.id}"
          puts "  NAME: #{product.name}"
        end

        block.call(product, path)
      end
    end

    def get_list_of_files(location)
      paths_for(location).select do |path|
        File.file?(path)
      end
    end

    def get_list_of_directories(location)
      paths_for(location).select do |path|
        File.directory?(path)
      end
    end

    def paths_for(location)
      Dir.glob(File.join(location, '*'))
    end
  end
end
