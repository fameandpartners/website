class CustomDressesMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def request_custom_dress(dress_request)
    @dress_request = dress_request

    mail(
      to: 'team@fameandpartners.com',
      from: @dress_request.email,
      subject: "Custom Dress Enquiry"
    )
  end
end
