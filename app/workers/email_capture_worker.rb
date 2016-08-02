class EmailCaptureWorker
  include Sidekiq::Worker
  sidekiq_options retry: true

  def perform(params)
    EmailCapture.new({ service: :mailchimp }, email: params['user']['email'],  newsletter: params['user']['newsletter'],
                     first_name: params['user']['first_name'], last_name: params['user']['last_name'],
                     current_sign_in_ip: params['remote_ip'], landing_page: params['landing_page'],
                     utm_params: params['utm_params'], site_version: params['site_version'],
                     form_name: 'Register').capture
  end
end
