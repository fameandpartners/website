class Spree::UserMailer < ActionMailer::Base
  layout 'mailer'

  default :from => configatron.noreply

  def welcome(user)
    @user = user
    mail(:to => user.email,
         :subject => t('emails.subjects.users.welcome') + ' to ' + Spree::Config[:site_name])
  end

  def welcome_with_password(user)
    @user = user
    mail(:to => user.email,
         :subject => t('emails.subjects.users.welcome') + ' to ' + Spree::Config[:site_name])
  end

  def welcome_to_competition(user)
    @user = user
    mail(:to => user.email,
         :subject => t('emails.subjects.users.welcome') + ' to ' + Spree::Config[:site_name])
  end

  def reset_password_instructions(user)
    @edit_password_reset_url = "#{configatron.fame_webclient_url}/account/forgot-password/token/#{@user.reset_password_token}"

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'account_password_reset',
      password_reset_link: @edit_password_reset_url
    )
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
  
  def style_profile_created(user)
    @user = user
    mail(:to => @user.email,
         :subject => Spree::Config[:site_name] + ' ' + t('emails.subjects.users.style_profile'))
  end
end
