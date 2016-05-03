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
    line_items = order_presenter.extract_line_items
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
      NewRelic::Agent.notice_error(e)
  end
end
