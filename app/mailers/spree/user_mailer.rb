class Spree::UserMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def welcome(user)
    @user = user
    mail(:to => user.email,
         :subject => t('emails.subjects.users.welcome') + ' to ' + Spree::Config[:site_name])
  end

  def reset_password_instructions(user)
    @edit_password_reset_url = spree.edit_spree_user_password_url(:reset_password_token => user.reset_password_token)

    mail(:to => user.email,
         :subject => Spree::Config[:site_name] + ' ' + I18n.t(:password_reset_instructions))
  end

  def confirmation_instructions(user, opts={})
    @user = user

    mail(:to => user.email,
         :subject => Spree::Config[:site_name] + ' ' + I18n.t('emails.subjects.users.confirmation'))
  end

  def custom_dress_created(custom_dress)
    @custom_dress = custom_dress
    @user = custom_dress.spree_user
    mail(:to => @user.email,
         :subject => Spree::Config[:site_name] + ' ' + t('emails.subjects.users.custom_dress'))
  end
end
