# TODO: this should be replaced with the MailChimp Client engine. The engine works with background workers and it uses an updated MailChimp API client lib: gibbon
class EmailCapture

  attr_reader :service, :mailchimp_struct, :email,
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
        site_add_source:  site_version,
        landing_page:     landing_page,
        utm_term:         utm_params,
        site_add_source:  form_name,
        newsletter:       newsletter
      }
    }
  end

  def email_changed?
    return if !previous_email.present? #|| previous_email.blank?
    return true if email != previous_email
  end

  def set_merge
    utm_params   = get_utm
    first_name   = retrieve_first_name
    last_name    = retrieve_last_name
    landing_page = retrieve_landing_page
    site_version = retrieve_site_version

    merge_variables = {}

    if email_changed?
      #Making an assumption here: The only place where the email changes is on "Account Settings"
    else
      merge_variables[:fname]      = first_name if first_name.present?
      merge_variables[:lname]      = last_name if last_name.present?
      merge_variables[:ip_address] = current_sign_in_ip
      merge_variables[:country]    = FindCountryFromIP.new(current_sign_in_ip).country.country_name if FindCountryFromIP.new(current_sign_in_ip).country.present?
      merge_variables[:l_page]     = landing_page if landing_page.present?
      merge_variables[:s_version]  = site_version if site_version.present?
      merge_variables[:fb_uid]     = facebook_uid if facebook_uid.present?
      merge_variables[:form_name]  = form_name if form_name.present?

      if !utm_params.blank?
        merge_variables[:u_campaign] = utm_params[:utm_campaign]
        merge_variables[:u_source]   = utm_params[:utm_source]
        merge_variables[:u_medium]   = utm_params[:utm_medium]
        merge_variables[:u_term]     = utm_params[:utm_term]
        merge_variables[:u_content]  = utm_params[:utm_content]
      end

      merge_variables[:n_letter] = set_newsletter if newsletter.to_s.present?
    end

    merge_variables
  end

  def retrieve_first_name
    first_name.presence || nil
  end

  def retrieve_landing_page
    landing_page.presence || nil
  end

  def retrieve_last_name
    last_name.presence || nil
  end

  def set_newsletter
    return nil if newsletter.to_s.blank?
    sn = (newsletter ? 'yes' : 'no')
    sn
  end

  def get_utm
    utm_params.presence || nil
  end

  def retrieve_site_version
    site_version.presence || nil
  end

  def set_list_id
    configatron.mailchimp.list_id
  end

end
