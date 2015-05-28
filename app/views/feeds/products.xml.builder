xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title @config[:title]
    xml.description @config[:description]

    production_domain = @config[:domain]
    xml.link production_domain

    @items.each do |item|
      xml.item do
        xml.title item[:title]
        xml.link "http://#{production_domain}#{collection_product_path(item[:product])}?color=#{item[:color]}"
        xml.description CGI.escapeHTML(item[:description])

        xml.tag! "g:id", item[:id]
        xml.tag! "g:condition", "new"
        xml.tag! "g:price", item[:price]
        xml.tag! "g:availability", item[:availability]
        xml.tag! "g:image_link", item[:image]
        xml.tag! "g:shipping_weight", item[:weight]

        xml.tag! "g:google_product_category", CGI.escapeHTML(item[:google_product_category])
        xml.tag! "g:gender", "Female"
        xml.tag! "g:age_group", "Adult"
        xml.tag! "g:color", item[:color]
        xml.tag! "g:size", item[:size]

        xml.tag! "g:item_group_id", item[:group_id]

        xml.tag! "g:brand", "Fame&Partners"
        xml.tag! "g:product_type"
        item[:images].each do |image|
          xml.tag! "g:additional_image_link", image
        end
      end
    end
  end
end
