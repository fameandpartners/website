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
end
