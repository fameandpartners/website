module Bergen
  module Operations
    class ReceiveBergenParcel

      attr_reader :item_return

      def initialize(item_return:)
        @item_return = item_return
      end

      def process
        if presenter.accepted?
          item_return.update_attribute(:acceptance_status, :approved)
          CustomerServiceMailer.accepted_parcel(item_return: item_return).deliver
        else
          item_return.update_attribute(:acceptance_status, :rejected)
          CustomerServiceMailer.rejected_parcel(item_return: item_return).deliver
        end

        # TODO: 13/07/2016 temporarily disabling customer facing emails due to worker triggering too many times
        # CustomerMailer.received_parcel(item_return: item_return).deliver
      end

      private

      def presenter
        Presenters::ItemReturnPresenter.new(item_return: item_return)
      end
    end
  end
end
