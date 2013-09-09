class ProductReservationsMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def new_reservation(product_reservation)
    @reservation = product_reservation

    mail(
      to: 'team@fameandpartners.com',
      subject: "Product Reservation created"
    )
  end
end
