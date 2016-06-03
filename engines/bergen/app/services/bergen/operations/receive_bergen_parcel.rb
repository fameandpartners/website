module Bergen
  module Operations
    class ReceiveBergenParcel

      attr_reader :item_return

      def initialize(item_return:)
        @item_return = item_return
      end

      def process
        if presenter.accepted?
          CustomerServiceMailer.accepted_parcel(item_return: item_return).deliver
        else
          CustomerServiceMailer.rejected_parcel(item_return: item_return).deliver
        end
      end

      private

      def presenter
        Presenters::ItemReturnPresenter.new(item_return: item_return)
      end
    end
  end
end
