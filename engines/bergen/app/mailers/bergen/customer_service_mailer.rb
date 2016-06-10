module Bergen
  class CustomerServiceMailer < ActionMailer::Base
    default to: %w(team@fameandpartners.com returns@fameandpartners.com),
            from: 'bergen-3pl@fameandpartners.com'

    def accepted_parcel(item_return:)
      @item_return = presenter(item_return)

      mail(
        subject: "ACCEPTED - Order #{item_return.order_number} received",
        template_name: 'received_parcel'
      )
    end

    def rejected_parcel(item_return:)
      @item_return = presenter(item_return)

      mail(
        subject: "REJECTED - Order #{item_return.order_number} received",
        template_name: 'received_parcel'
      )
    end

    private

    def presenter(item_return)
      Presenters::ItemReturnPresenter.new(item_return: item_return)
    end
  end
end
