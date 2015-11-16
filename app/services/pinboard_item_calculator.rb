class PinboardItemCalculator < EventSourcedRecord::Calculator
  events :pinboard_item_events

  def advance_creation(event)
    @pinboard_item.pinboard_id = event.pinboard_id
    @pinboard_item.product_id = event.product_id
    @pinboard_item.product_color_value_id = event.product_color_value_id
    # @pinboard_item.color_id = event.color_id
    @pinboard_item.added_user_id = event.user_id

    # pinboard_id:            pinboard_id,
    # product_id:             product_id,
    # product_color_value_id: pcv.id,
    # color_id:               color_id,
    # user_id:                user.id
    # def advance_creation(event)
    #   @fabrication.state        = :new
    #   @fabrication.line_item_id = event.line_item_id
    # end
    # @pinboard_item.

    # binding.pry
  end



end
