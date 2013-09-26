class Spree::AdminMailer  < ActionMailer::Base
  default :from => configatron.noreply,
          :to   => configatron.admin

  def custom_dress_created(custom_dress)
    @dress = custom_dress
    @user = custom_dress.spree_user
    mail(
      :from => @user.email,
      :subject => t('emails.subjects.admins.custom_dress', :full_name => @user.full_name, :id => @user.id)
    )
  end

  def product_personalized(personalization)
    @personalization = personalization

    to = 'team@fameandpartners.com'
    subject = 'Product Customization'
    from = "#{@personalization.user_full_name}<#{@personalization.user_email}>"

    mail(to: to, from: from, subject: subject)
  end

  def stylist_consultation_requested(user)
    @user = user

    to = 'team@fameandpartners.com'
    subject = 'Stylist consultation requested'
    from = "#{@user.full_name}<#{@user.email}>"

    mail(to: to, from: from, subject: subject)
  end
end
