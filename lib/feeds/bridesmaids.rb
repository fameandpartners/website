module Feeds
  class Bridesmaids

    SIZES = %w(
      US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
      US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
    )

    COLORS = [
      "Ivory",
      "Pale Grey",
      "Black",
      "Champagne",
      "Pale Pink",
      "Blush",
      "Peach",
      "Guava",
      "Red",
      "Burgundy",
      "Berry",
      "Lilac",
      "Navy",
      "Royal Blue",
      "Pale Blue",
      "Mint",
      "Bright Turquoise",
      "Sage Green"
    ].join(',')

    def generate_xml
      categories = Category.where(category: 'Bridesmaids').pluck(:id)
      products = Spree::Product.where(category_id: categories)

      memoize_values(products)

      products.each_with_index do |product, index|
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
        file_path = Rails.root.join('public', "bm#{index}.xml")
        f = File.new(file_path , 'w')

        xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
          xml.channel do
            xml.title 'Fame & Partners'
            xml.description 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.'
            xml.link 'https://www.fameandpartners.com'

            product.customization_visualizations.find_each do |cv|
            # product.customization_visualizations.take(1).each do |cv|
              # SIZES.each do |size|
                # JSON.parse(cv.render_urls).each do |color_hash|
                #   if color_hash.first == 'render_urls'
                #     next
                #   end
                  customizations = cv_ids_to_customizations_json(cv, product.name)
                  xml.item do
                    xml.title product.name
                    xml.link "#{cv.length} Length #{cv.silhouette} Dress with #{cv.neckline} #{cv.neckline.include?('Neckline') ? '' : 'Neckline'}"
                    xml.description product.description

                    xml.tag! "events", 'Bridesmaids'
                    xml.tag! "styles", 'Long,Halter,Backless,Evening-Shop-Gown,Evening-Shop-Plunging,Dress'
                    xml.tag! "lookbooks", ''

                    xml.tag! "g:id", cv.id.to_s
                    xml.tag! "g:condition", "new"
                    xml.tag! "g:price", "fooooooooo"
                    xml.tag! "g:sale_price", ""
                    xml.tag! "g:availability", "in stock"
                    xml.tag! "g:image_link", BridesmaidHelper.generate_image(customizations, cv.length, product.master.sku, {presentation: 'Ivory'})[:xlarge]
                    xml.tag! "g:shipping_weight", ""

                    xml.tag! "g:google_product_category", "Bridal & Bridesmaids"
                    xml.tag! "product_type", "not-a-dress"
                    xml.tag! "g:gender", "Female"
                    xml.tag! "g:age_group", "Adult"
                    xml.tag! "g:color", COLORS
                    xml.tag! "g:size", ''

                    xml.tag! "g:item_group_id", '283'

                    xml.tag! "g:mpn", ''

                    xml.tag! "g:brand", "Fame&Partners"
                  end
                # end
              # end
            end
          end
        end
          # binding.pry
        f.write(xml.target!)
        f.close
      end
    end

    def memoize_values(products)
      @lookup_customization = {}
      @lookup_price = {}

      products.each do |prd|
        cust_hash = {}
        len_hash = {}

        JSON.parse(prd.customizations).each do |cust|
          cust_hash[cust["customisation_value"]['id']] = cust["customisation_value"]
        end

        JSON.parse(prd.lengths)['available_lengths'].each do |l|
          len_hash[l['name']] = l
        end

        @lookup_customization[prd.name] = cust_hash
        @lookup_price[prd.name] = len_hash
      end
    end

    def get_rendered_image(cv, prd, color)
      customizations = cv_ids_to_customizations_json(cv, prd.name)

      # Rails.cache.fetch("#{cv.id}#{color}", expires_in: 10.hours) do
        # image_val = ""
        # COLORS.each do |pcolor|
          image_link = BridesmaidHelper.generate_image(customizations, cv.length, prd.master.sku, 'Ivory')[:xlarge]
          # if pcolor == color
          #   image_val = image_link
          # end
        # end
        # image_val
      # end
    end

    def cv_ids_to_customizations_json(cv, prd_name)
      cids_arr = cv.customization_ids.split('_')
      customizations_arr = []

      cids_arr.each do |id|
        customizations_arr << {"customisation_value" => @lookup_customization[prd_name][id]}
      end
      customizations_arr
    end


  end
end
