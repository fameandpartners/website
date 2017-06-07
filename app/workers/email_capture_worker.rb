class EmailCaptureWorker
  include Sidekiq::Worker

  # TODO: EmailCapture needs to be replaced with MailChimpClient engine
  def perform(user_id, params)
    user = Spree::User.find(user_id)
    EmailCapture.new({ service: configatron.subscription_service }, email: user.email,  newsletter: user.newsletter,
                     first_name: user.first_name, last_name: user.last_name,
                     current_sign_in_ip: params['remote_ip'], landing_page: params['landing_page'],
                     utm_params: params['utm_params'], site_version: params['site_version'],
                     form_name: params['form_name']).capture
  end
end
