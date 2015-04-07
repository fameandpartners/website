module Marketing; end

class Marketing::RakutenTracker
  attr_reader :order, :site_version, :mid, :cur, :ord

  LineItem = Struct.new(:sku, :quantity, :name, :price, :gst) do
    def price_gst
      gst_ex_price = (price / 1.1)
      (gst_ex_price * 100).round.to_i
    end

    def price_cents
      (price * 100).round.to_i
    end

    # AU needs to account for gst
    def total_price
      if gst
        price_gst * qty
      else
        price_cents * qty
      end
    end

    def qty
      [quantity.to_i, 1].max
    end
  end

  def initialize(order, site_version)
    @order = order
    @site_version = site_version

    if site_version.is_usa?
      @mid = '40178'
      @cur = 'USD'
    else
      @mid = '40212'
      @cur = 'AUD'
    end

    ord = @order.number
  end

  def skulist
    items.collect{ |i| i.sku }.join('|')
  end

  def qlist
    items.collect{ |i| i.quantity }.join('|')
  end

  def namelist
    items.collect{ |i| i.name }.join('|')
  end

  def amtlist
    items.collect{ |i| i.total_price }.join('|')
  end

  def promo?
    promo_total < 0
  end

  def promo_total
    @promo_total ||= @order.adjustments.where("originator_type = 'Spree::PromotionAction'").sum(:amount)
  end

  def line_item(item)
    sku = item.variant.sku || item.variant.product.sku
    LineItem.new(sku, item.quantity, item.variant.product.name, item.price, site_version.is_australia?)
  end

  def items
    @items ||= build_items_with_discount
  end

  def build_items_with_discount
    items = @order.line_items.collect{ |i| line_item(i) }

    if promo?
      items << LineItem.new('Discount', 0, 'Discount', promo_total, site_version.is_australia?)
    end
    items
  end

  def url
    "http://track.linksynergy.com/ep?mid=#{mid}&ord=#{ord}&skulist=#{skulist}&qlist=#{qlist}&amtlist=#{amtlist}&cur=#{cur}&img=1&namelist=#{namelist}"
  end

end
