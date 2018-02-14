module Feeds
  class Bridesmaids
    include ProductsHelper

    SIZES = %w(
      US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
      US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
    )

    COLOR_MAP = {
      'Bright Turquoise' => '0000',
      'Pale Blue' => '0001',
      'Blush' =>'0002',
      'Guava' => '0003',
      'Burgundy' => '0004',
      'Champagne' => '0005',
      'Ivory' => '0006',
      'Lilac' => '0007',
      'Mint' => '0008',
      'Pale Grey' => '0009',
      'Pale Pink' => '0010',
      'Peach' => '0011',
      'Red' => '0012',
      'Royal Blue' => '0013',
      'Black' => '0014',
      'Sage Green' => '0015',
      'Berry'=> '0016',
      'Navy' => '0017',
    }

    def generate_xml
      colors = fabric_swatch_colors.map{|swatch| swatch[:color_name]}
      categories = Category.where(category: 'Bridesmaids').pluck(:id)
      products = Spree::Product.where(category_id: categories)

      memoize_values(products)

      products.each_with_index do |product, index|
        xml = Builder::XmlMarkup.new
        xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
        file_path = Rails.root.join('public/feeds/us/products/', "bridesmaids-#{index}.xml")
        f = File.new(file_path , 'w')

        xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
          xml.channel do
            xml.title 'Fame & Partners'
            xml.description 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.'
            xml.link 'https://www.fameandpartners.com'

            product.customization_visualizations.find_each do |cv|
              calculate_price(cv)

              customizations = cv_ids_to_customizations_json(cv, product.name)
              customization_ids = customizations.reject{|y| y['customisation_value']['id'][0].downcase == 'l'}.map{|x| x['customisation_value']['id']}.sort.join('-')
              customization_ids = customization_ids.blank? ? 'default' : customization_ids

              colors.each do |color|
                xml.item do
                  xml.title "#{product.name}-#{cv.length} Length #{cv.silhouette} Dress with #{cv.neckline} #{cv.neckline.include?('Neckline') ? '' : 'Neckline'}"
                  xml.link "https://www.fameandpartners.com/bridesmaid-dresses/#{cv.id}?color=#{color}&length=#{cv.length}"
                  xml.description product.description

                  xml.tag! "events", 'Bridesmaids'
                  xml.tag! "styles", ''
                  xml.tag! "lookbooks", ''

                  xml.tag! "g:id", cv.id.to_s
                  xml.tag! "g:condition", "new"
                  xml.tag! "g:price", calculate_price(cv)
                  xml.tag! "g:sale_price", ""
                  xml.tag! "g:availability", "in stock"
                  xml.tag! "g:image_link", "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{product.master.sku.downcase}/142x142/#{customization_ids}-#{cv.length.downcase}-front-#{COLOR_MAP[color]}.png"
                  xml.tag! "g:shipping_weight", ""

                  xml.tag! "g:google_product_category", "Bridal & Bridesmaids"
                  xml.tag! "product_type", "not-a-dress"
                  xml.tag! "g:gender", "Female"
                  xml.tag! "g:age_group", "Adult"
                  xml.tag! "g:color", color
                  xml.tag! "g:size", ''

                  xml.tag! "g:item_group_id", ''
                  xml.tag! "g:mpn", ''
                  xml.tag! "g:brand", "Fame&Partners"
                end
              end
            end
          end
        end
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

    def calculate_price(cv)
      cids_arr = cv.customization_ids.split('_')
      base_price = @lookup_price[cv.product.name][cv.length]['price_usd'].to_i
      add_ons_price = cids_arr.reduce(0) {|total, id| total += @lookup_customization[cv.product.name][id]['price'].to_i}
      sprintf('%.2f', (base_price + add_ons_price).to_f)
    end

    # def get_rendered_image(cv, prd, color)
    #   customizations = cv_ids_to_customizations_json(cv, prd.name)

    #   # Rails.cache.fetch("#{cv.id}#{color}", expires_in: 10.hours) do
    #     # image_val = ""
    #     # COLORS.each do |pcolor|
    #       image_link = BridesmaidHelper.generate_image(customizations, cv.length, prd.master.sku, 'Ivory')[:xlarge]
    #       # if pcolor == color
    #       #   image_val = image_link
    #       # end
    #     # end
    #     # image_val
    #   # end
    # end

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
