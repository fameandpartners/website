class EmailCapture

  attr_accessor :service, :mailchimp

  def initialize(options = {})
    @service = options[:service].downcase
    case service
      when 'mailchimp'
        @mailchimp = Mailchimp::API.new(configatron.mailchimp.api_key)
    end
  end

  def capture(data_object)

    if service == 'mailchimp'
      current_email = data_object

      get_email = email_changed?(current_email) ? current_email.email_was : current_email.email

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
    return false if current_email.class.to_s == 'Contact'
    current_email.email_changed? && !current_email.email_was.blank?
  end

  def retrieve_first_name(c_email)
    first_name = nil
    case
      when c_email.class.to_s == 'Contact'
        first_name = c_email.first_name
      when c_email.class.to_s == 'OpenStruct'
        first_name = c_email.first_name
      else
        first_name = c_email.first_name if c_email.attributes.key?('first_name')
        first_name = c_email.firstname if c_email.attributes.key?('firstname')
    end
    first_name
  end

  def retrieve_landing_page(c_email)
    landing_page = nil
    case
      when c_email.class.to_s == 'Contact'
        landing_page = c_email.landing_page
      when c_email.class.to_s == 'OpenStruct'
        landing_page = c_email.landing_page
      else
        landing_page = c_email.landing_page if c_email.attributes.key?('landing_page')
    end
    landing_page
  end

  def retrieve_last_name(c_email)
    last_name = nil
    case
      when c_email.class.to_s == 'Contact'
        last_name = c_email.last_name
      when c_email.class.to_s == 'OpenStruct'
        last_name = c_email.last_name
      else
        last_name = c_email.last_name if c_email.attributes.key?('last_name')
        last_name = c_email.lastname if c_email.attributes.key?('lastname')
    end
    last_name
  end

  def set_newsletter(c_email)
    newsletter = nil
    newsletter = (c_email.newsletter ? 'yes' : 'no') if c_email.newsletter || !c_email.newsletter
    newsletter
  end

  def activerecord?(d_object)
    d_object.class.ancestors.include?(ActiveRecord::Base)
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
      merge_variables[:ip_address] = '101.0.79.50' #data_object.current_sign_in_ip
      merge_variables[:country]    = FindCountryFromIP.new('101.0.79.50').country.country_name
      merge_variables[:l_page]     = landing_page if landing_page.present?
      merge_variables[:s_version]  = site_version if site_version.present?
      merge_variables[:fb_uid]     = current_email.facebook_uid if current_email.facebook_uid.present?

      if !utm_params.blank?
        merge_variables[:u_campaign] = utm_params[:utm_campaign]
        merge_variables[:u_source]   = utm_params[:utm_source]
        merge_variables[:u_medium]   = utm_params[:utm_medium]
        merge_variables[:u_term]     = utm_params[:utm_term]
        merge_variables[:u_content]  = utm_params[:utm_content]
      end

      merge_variables[:n_letter]   = set_newsletter(current_email) if set_newsletter(current_email).present?
    end

    merge_variables
  end

  def get_utm(d_o)
    utm_params = nil
    case
      when d_o.class.to_s == 'Contact'
        utm_params = d_o.utm_params
      when d_o.class.to_s == 'OpenStruct'
        utm_params = d_o.utm_params
      else
        d_o = d_o.utm_params if d_o.attributes.key?('utm_params')
    end
    utm_params
  end

  def retrieve_site_version(d_o)
    site_version = nil
    case
      when d_o.class.to_s == 'Contact'
        site_version = d_o.site_version
      when d_o.class.to_s == 'OpenStruct'
        site_version = d_o.site_version
      else
        site_version = d_o.site_version if d_o.attributes.key?('site_version')
    end
    site_version
  end

end
