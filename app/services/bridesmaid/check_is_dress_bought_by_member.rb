# note:
#   - if member have bought dresses from bride moodboard.
#   - notify bride about it.
class Bridesmaid::CheckIsDressBoughtByMember
  attr_reader :order

  # Bridesmaid::CheckIsDressBoughtByMember.new(order: self).process
  def initialize(options = {})
    @order = options[:order]
  end

  def process
    # find accessor
    # find bride partys where accessor is not bride
    # check bought dress
    # if dress bought from moodboard
    #   - update membership with 'bought'
    #   - notify
  end

  def process
    bridesmaid_party_events.each do |event|
      moodboard = Bridesmaid::Moodboard.new(
        site_version: site_version,
        accessor: order.user,
        moodboard_owner: event.spree_user
      ).read

      # if cart have line item with the same dress, what have been selected by bride
      items = bought_items_from_moodboard(moodboard.products)
      if items.present?
        BridesmaidPartyMailer.delay.bridesmaid_purchase(
          items: items,
          bride: event.spree_user,
          user: order.user
        )
      end
    end
  end

  private

    def site_version
      @site_version ||= begin
        currency = order.currency  || 'USD'
        SiteVersion.where(currency: currency).first || SiteVersion.default
      end
    end

    def bridesmaid_party_events
      @bridesmaid_party_events ||= begin
        user = order.user
        event_ids = BridesmaidParty::Member.where(spree_user_id: user.id).pluck(:event_id)
        BridesmaidParty::Event.where(id: event_ids, paying_for_bridesmaids: false).includes(:spree_user)
      end
    end

    def line_items
      @line_items ||= order.line_items.includes(:personalization, :variant)
    end

    # Cart Repo?
    def bought_items_from_moodboard(moodboard_items)
      line_items.map do |line_item|
        moodboard_items.collect do |moodboard_item|
          if is_equal_items?(line_item, moodboard_item)
            prepare_item(line_item, moodboard_item)
          else
            nil
          end
        end
      end.flatten.compact
    end

    def is_equal_items?(line_item, moodboard_item)
      return false if line_item.variant.product_id != moodboard_item.product_id

      if line_item.variant.is_master?
        if line_item.personalization.present?
          line_item.personalization.color_id == moodboard_item.color.id
        else
          false
        end
      else
        # compare color, not variant 
        line_item.variant.dress_color.try(:id) == moodboard_item.color.id
      end
    end

    def prepare_item(line_item, moodboard_item)
      variant = line_item.variant
      if variant.is_master?
        size = line_item.personalization.try(:size).to_s
      else
        size = variant.dress_size.try(:presentation)
      end

      line_item.variant.dress_size
        FastOpenStruct.new({
          image_url: moodboard_item.image_url,
          name: moodboard_item.name,
          price: moodboard_item.price,
          color: moodboard_item.color.name,
          size: size
        })
    end
end
