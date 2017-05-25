module Bergen
  class CustomerMailer < ActionMailer::Base
    default from: 'noreply@fameandpartners.com'

    def received_parcel(item_return:)
      mail(
        to: item_return.contact_email,
        subject: "Fame and Partners Order #{item_return.order_number} - Package Received"
      )
    end
  end
end
