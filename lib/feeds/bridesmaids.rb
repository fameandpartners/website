module Feeds
  class Bridesmaids

    SIZES = %w(
      US0/AU4   US2/AU6   US4/AU8   US6/AU10  US8/AU12  US10/AU14
      US12/AU16 US14/AU18 US16/AU20 US18/AU22 US20/AU24 US22/AU26
    )

    def generate_xml
      categories = Category.where(category: 'Bridesmaids').pluck(:id)
      products = Spree::Product.where(category_id: categories)

      xml = Builder::XmlMarkup.new
      xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'

      products.each do |product, index|
        file_path = Rails.root.join('public', "bm#{index}.xml")
        f = File.new(file_path , 'w')

        xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
          xml.channel do
            xml.title 'Fame & Partners'
            xml.description 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.'
            xml.link 'https://www.fameandpartners.com'

              product.customization_visualizations.find_each do |cv|
                SIZES.each do |size|
                  JSON.parse(cv.render_urls).each do |color_hash|
                    if color_hash.first == 'render_urls'
                      next
                    end
                    xml.item do
                      xml.title cv.product.name
                      xml.link "#{cv.length} Length #{cv.silhouette} Dress with #{cv.neckline} #{cv.neckline.include?('Neckline') ? '' : 'Neckline'}"
                      xml.description cv.product.description

                      xml.tag! "events", 'Bridesmaids'
                      xml.tag! "styles", 'Long,Halter,Backless,Evening-Shop-Gown,Evening-Shop-Plunging,Dress'
                      xml.tag! "lookbooks", ''

                      xml.tag! "g:id", cv.id.to_s
                      xml.tag! "g:condition", "new"
                      xml.tag! "g:price", "fooooooooo"
                      xml.tag! "g:sale_price", ""
                      xml.tag! "g:availability", "in stock"
                      xml.tag! "g:image_link", "blblafooooooooolblbalbla"
                      xml.tag! "g:shipping_weight", ""

                      xml.tag! "g:google_product_category", "Bridal & Bridesmaids"
                      xml.tag! "product_type", "not-a-dress"
                      xml.tag! "g:gender", "Female"
                      xml.tag! "g:age_group", "Adult"
                      xml.tag! "g:color", color_hash["color"]
                      xml.tag! "g:size", size

                      xml.tag! "g:item_group_id", '283'

                      xml.tag! "g:mpn", ''

                      xml.tag! "g:brand", "Fame&Partners"
                    end
                  end
                end
              end
            end
          end
        end

binding.pry
      f.write(xml)
      f.close
    end
  end
end
