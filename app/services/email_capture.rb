class EmailCapture

  attr_reader :service, :mailchimp, :mailchimp_struct

  def initialize(options = {})
    @service          = options[:service]
    @mailchimp        = Mailchimp::API.new(configatron.mailchimp.api_key)
    @mailchimp_struct = Struct.new("Mailchimp", :email,
                                   :previous_email, :newsletter, :first_name,
                                   :last_name, :current_sign_in_ip, :landing_page,
                                   :utm_params, :site_version, :facebook_uid,
                                   :form_name)
  end

  def capture(current_email)

    if service == :mailchimp

      get_email = email_changed?(current_email) ? current_email.previous_email : current_email.email

      merge_variables = set_merge(current_email)

      begin
        if email_changed?(current_email)
          #Making an assumption here: The only place where the email changes is on "Account Settings"
          update_list(get_email, current_email.email, retrieve_first_name(current_email), retrieve_last_name(current_email))
        else
          subscribe_list(current_email.email, merge_variables)
        end
      rescue Mailchimp::ValidationError => e
        NewRelic::Agent.notice_error("Mailchimp: #{e} for #{current_email.email}")
      end
    end

  end

  def update_list(get_email, current_email, first_name, last_name)
    subscriber = mailchimp.lists.members(configatron.mailchimp.list_id)['data'].select { |subscriber| subscriber['email'] == get_email }
    mailchimp.lists.update_member(configatron.mailchimp.list_id, {"leid" => subscriber[0]['leid']},
                                  {email: current_email,
                                   fname: first_name,
                                   lname: last_name})
  end

  def subscribe_list(current_email, merge_variables)
    mailchimp.lists.subscribe(configatron.mailchimp.list_id, {"email" => current_email},
                              merge_variables, 'html', false, true, true, false)
  end

  def email_changed?(current_email)
    return false if !defined?(current_email.previous_email) || current_email.previous_email.blank?
    return true if current_email.email != current_email.previous_email
  end

  def set_merge(current_email)
    utm_params   = get_utm(current_email)
    first_name   = retrieve_first_name(current_email)
    last_name    = retrieve_last_name(current_email)
    landing_page = retrieve_landing_page(current_email)
    site_version = retrieve_site_version(current_email)

    merge_variables = {}

    if email_changed?(current_email)
      #Making an assumption here: The only place where the email changes is on "Account Settings"
    else
      merge_variables[:fname]      = first_name if first_name.present?
      merge_variables[:lname]      = last_name if last_name.present?
      merge_variables[:ip_address] = current_email.current_sign_in_ip
      merge_variables[:country]    = FindCountryFromIP.new(current_email.current_sign_in_ip).country.country_name if FindCountryFromIP.new(current_email.current_sign_in_ip).country.present?
      merge_variables[:l_page]     = landing_page if landing_page.present?
      merge_variables[:s_version]  = site_version if site_version.present?
      merge_variables[:fb_uid]     = current_email.facebook_uid if current_email.facebook_uid.present?
      merge_variables[:form_name]  = current_email.form_name if current_email.form_name.present?

      if !utm_params.blank?
        merge_variables[:u_campaign] = utm_params[:utm_campaign]
        merge_variables[:u_source]   = utm_params[:utm_source]
        merge_variables[:u_medium]   = utm_params[:utm_medium]
        merge_variables[:u_term]     = utm_params[:utm_term]
        merge_variables[:u_content]  = utm_params[:utm_content]
      end

      merge_variables[:n_letter] = set_newsletter(current_email) if set_newsletter(current_email).present?
    end

    merge_variables
  end

  def retrieve_first_name(d_o)
    d_o.try(:first_name)
  end

  def retrieve_landing_page(d_o)
    d_o.try(:landing_page)
  end

  def retrieve_last_name(d_o)
    d_o.try(:last_name)
  end

  def set_newsletter(d_o)
    return nil if d_o.newsletter.to_s.blank?
    newsletter = (d_o.newsletter ? 'yes' : 'no')
    newsletter
  end

  def get_utm(d_o)
    d_o.try(:utm_params)
  end

  def retrieve_site_version(d_o)
    d_o.try(:site_version)
  end

end
