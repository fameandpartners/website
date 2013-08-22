class CustomDressesMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def request_custom_dress(info)
    @info = info

    mail(
      to: 'team@fameandpartners.com',
      from: @info[:email],
      subject: "Custom Dress Enquiry"
    )
  end
end
