class EmailCapture

  attr_reader :service, :email,
              :previous_email, :newsletter, :first_name,
              :last_name, :current_sign_in_ip,
              :landing_page, :utm_params, :site_version,
              :facebook_uid, :form_name

  def initialize(options = {}, email:, previous_email: nil, newsletter: nil,
                 first_name: nil, last_name: nil, current_sign_in_ip:, landing_page:,
                 utm_params: nil, site_version:, facebook_uid: nil, form_name:)

    @service            = options[:service] ? options[:service].to_sym : :bronto
    @email              = email
    @previous_email     = previous_email
    @newsletter         = newsletter
    @first_name         = first_name
    @last_name          = last_name
    @current_sign_in_ip = current_sign_in_ip
    @landing_page       = landing_page
    @utm_params         = utm_params
    @site_version       = site_version
    @facebook_uid       = facebook_uid
    @form_name          = form_name
  end

  def capture
    begin
      resultpe = Bronto::SubscribeUsersService.perform(ENV.fetch('BRONTO_SUBSCRIPTION_LIST'), [user_data])
    rescue Savon::SOAP::Fault => e
      puts "********** Error *************"
      puts e
      NewRelic::Agent.notice_error("Bronto error: #{e} for #{email}")
    end
  end

  # user data we pass to bronto worker
  def user_data
    {
      email: email,
      fields: {
        lastname:         last_name,
        firstname:        first_name,
        facebook_UID:     facebook_uid,
        ip_address:       current_sign_in_ip,
        landing_page:     landing_page,
        utm_term:         utm_params,
        site_add_source:  form_name,
        newsletter:       newsletter
      }
    }
  end
end
