class Spree::AdminMailer  < ActionMailer::Base
  default :from => configatron.noreply,
          :to   => configatron.admin

  def custom_dress_created(custom_dress)
    @custom_dress = custom_dress
    @user = custom_dress.spree_user
    mail(:subject => t('emails.subjects.admins.custom_dresses.created'))
  end
end
