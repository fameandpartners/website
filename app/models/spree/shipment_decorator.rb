Spree::Shipment.class_eval do
  def is_dhl?
    shipping_method? /dhl/i
  end

  def is_auspost?
    shipping_method? /auspost/i
  end

  def is_tnt?
    shipping_method? /tnt/i
  end

  def tracking_url
    if is_dhl?
      "http://www.dhl.com/content/g0/en/express/tracking.shtml?brand=DHL&AWB=#{ tracking }"
    elsif is_auspost?
      "http://auspost.com.au/track/track.html?id=#{ tracking }"
    elsif is_tnt?
      "http://www.tnt.com/webtracker/tracking.do?respCountry=us&respLang=en&navigation=1&page=1&sourceID=1&sourceCountry=ww&plazaKey=&refs=&requesttype=GEN&searchType=CON&cons=#{ tracking }"
    end
  end

  private
  def shipping_method?(matcher)
    !! (shipping_method.name =~ matcher)
  end

  def send_shipped_email
    @shipment = self
    subject = "Hey babe, your dress is on it's way - Order: ##{@shipment.order.number}"

    order_presenter = Orders::OrderPresenter.new(@shipment.order, @shipment.line_items)
    line_items = extract_line_items(order_presenter)
    Marketing::CustomerIOEventTracker.new.track(
      self.order.user,
      'shipment_mailer',
      email_to:              @shipment.order.email,
      from:                  'noreply@fameandpartners.com',
      subject:               subject,
      date:                  Date.today.to_formatted_s(:long),
      name:                  order.first_name.rstrip,
      shipment_method_name:  @shipment.shipping_method.name,
      line_items:            line_items,
      shipment_tracking:     @shipment.tracking,
      shipment_tracking_url: @shipment.blank? ? "#" : @shipment.tracking_url
    )
    rescue StandardError => e
      byebug
      NewRelic::Agent.notice_error(e)
    end
  end

  def extract_line_items(order_presenter)
    order_presenter.line_items.collect do |item|
      {
        style_name:       item.style_name,
        style_num:        item.style_number,
        sku:              item.sku,
        line_item_id:     item.id,
        product_number:   item.product_number,
        size:             item.size,
        adjusted_size:    item.country_size,
        color:            item.colour_name,
        height:           item.height,
        quantity:         item.quantity,
        factory:          item.factory,
        deliver_date:     item.projected_delivery_date,
        express_making:   item.making_options.present? ? item.making_options.map{|option| option.name.upcase }.join(', ') : "",
        image_url:        item.image? ? item.image_url : ''
      }.merge(
         # Convert each element of the customisations array
         # to an explicit hash key and child hash.
         #
         # Customizations is an array , currently customerio does not support nested array in json properly and they are working on it
         # that's why the json receive on customerio is not formatted correctly which lead to failed emails
         # a hacking solution is pull out all elements in customizations array to seperate elements so customerio can read correctly
         # Current output will be line_items[{... customizations: []....customizations_0: [], customizations_1: [], customizations_2: []...}, {}]
         #
         # e.g. Where we would like to use an array;
         # :customizations=>[{:name=>"N/A", :url=>nil}, {:name=>"Cool", :url=>nil} ]
         # we must use merge a hash to the original result
         # :customizations_0=>{:name=>"N/A", :url=>nil},
         # :customizations_1=>{:name=>"Cool", :url=>nil},
        item.customisations.each_with_index.map do |(name, image_url), idx|
          ["customizations_#{idx}".to_sym, {name: name, url: image_url}]
        end.to_h
      )
  end

end
