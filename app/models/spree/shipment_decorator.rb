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

  def line_items
    if order.complete? and Spree::Config[:track_inventory_levels]
      order.line_items.select { |li| inventory_units.map(&:variant_id).include?(li.variant_id) }
    else
      order.line_items
    end
  end

  private
  def shipping_method?(matcher)
    !! (shipping_method.name =~ matcher)
  end

 end
