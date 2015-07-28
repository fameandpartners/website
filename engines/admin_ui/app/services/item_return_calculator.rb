class ItemReturnCalculator < EventSourcedRecord::Calculator
  events :item_return_events

  def advance_creation(event)
    @item_return.comments = ""
    @item_return.line_item_id = event.line_item_id
  end

  def advance_return_requested(event)
    event.data.map do |k,v|
      @item_return.send("#{k}=", v)
    end
  end

  def advance_receive_item(event)
    @item_return.acceptance_status = :received
    @item_return.received_location = event.location
    @item_return.received_on       = event.received_on
  end

  def advance_approve(event)
    @item_return.acceptance_status = :approved
    @item_return.comments = "#{@item_return.comments}#{event.comment}\n"
  end
end
