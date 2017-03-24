class BulkRefundWorker
  include Sidekiq::Worker

  def perform(user_id)
    @user = Spree::User.find(user_id)

    events = item_returns.map do |item_return|
      refund(item_return)
    end

    report(events)
  end

  private

  def report(events)
    BulkRefundMailer.report(events).deliver
  end

  # Need to memoize this list to avoid unprocessed items at email report.
  def item_returns
    @item_returns ||= ItemReturn.refund_queue.
                                 where('line_item_id IS NOT NULL')
  end

  # TODO: probably we need to implement more efficient refund calculation.
  def refund_amount_for(item_return)
    item_return.line_item.price
  end

  def refund(item_return)
    item_return.events.refund.create(user: @user,
                                     refund_amount: refund_amount_for(item_return),
                                     refund_method: 'Pin')
  end
end
