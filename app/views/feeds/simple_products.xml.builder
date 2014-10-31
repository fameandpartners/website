xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
  xml.products do
    xml.title 'Fame &amp; Partners Product Feed'
    xml.description 'Simple list of active products.'
    xml.products_count @color_variants.count

    production_domain = ActionMailer::Base.default_url_options[:host] || 'www.fameandpartners.com'
    xml.link production_domain

    @color_variants.each do |item|
      product = Spree::Product.where(:id => item.product.id).first
      xml.product do
        xml.sku product.sku
        xml.name item.product.name
        xml.link "http://#{production_domain}#{collection_product_path(item.product)}"
        xml.color item.color.presentation
        xml.price Money.new(item.prices[:aud], "AUD")
        xml.description CGI.escapeHTML(item.product.description)
        xml.categories do
          product.taxons.each do |taxon|
            xml.category taxon.name
          end
        end
        xml.image item.images.first[:large]
      end
    end
  end
