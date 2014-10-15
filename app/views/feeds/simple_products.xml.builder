cache :expires_in => configatron.cache.expire.long do
xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  xml.products do
    xml.title 'Fame &amp; Partners Product Feed'
    xml.description 'Simple list of active products.'
    xml.products_count @products.count

    production_domain = ActionMailer::Base.default_url_options[:host] || 'www.fameandpartners.com'
    xml.link production_domain

    @products.each do |product|
      #product = Spree::Product.where(:id => item.product.id).first
      price = product.zone_price_for(current_site_version).display_price
      color = product.variants.first.dress_color.try(:presentation)
      image = product.images.first ? product.images.first.attachment.url(:large) : "#{production_domain}/assets/noimage/product.png"
      xml.product do
        xml.sku product.sku
        xml.name product.name
        xml.link "http://#{production_domain}#{collection_product_path(product)}"
        xml.color color
        xml.price price
        xml.description CGI.escapeHTML(product.description)
        xml.categories do
          product.taxons.each do |taxon|
            xml.category taxon.name
          end
        end
        xml.image image
      end
    end
  end
end