class BulkRefundWorker
  include Sidekiq::Worker

  def perform(user_email)
    @user_email = user_email

    results =
    {
      success: [],
      error:   []
    }

    item_returns.each do |item_return|
      result = refund(item_return)
      results[result[:status]] << { item_return_id: item_return.id, result: result }
    end

    report(results)
  end

  private

  def user
    Spree::User.where(email: @user_email).first
  end

  def report(results)
    BulkRefundMailer.report(results, user).deliver
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

  def refund_data_for(item_return)
    {
      :user           => @user_email,
      "refund_amount" => refund_amount_for(item_return),
      "refund_method" => 'Pin'
    }
  end

  def refund(item_return)
    RefundService.new(item_return_id: item_return.id,
                      refund_data:    refund_data_for(item_return)).process
  end
end
