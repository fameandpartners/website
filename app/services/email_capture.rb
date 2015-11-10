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
    p "Here: #{data_object.inspect}"
    if service == 'mailchimp'

      current_email = return_email_object(data_object)
      p "Here: 4 #{current_email.class}"
      merge_variables = {}

      get_email = email_changed?(current_email) ? current_email.email_was : current_email.email

      subscriber = mailchimp.lists.members(configatron.mailchimp.list_id)['data'].select {|subscriber| subscriber['email'] == get_email }
      p "Here: EMAIL - #{email_changed?(current_email)} - #{subscriber}"

      first_name = retrieve_first_name(current_email)
      last_name = retrieve_last_name(current_email)

      if email_changed?(current_email)
        #Making an assumption here: The only place where the email changes is on "Account Settings"
        mailchimp.lists.update_member(configatron.mailchimp.list_id, { "leid" => subscriber[0]['leid'] },
                                      { email: current_email.email,
                                        fname: first_name,
                                        lname: last_name } )
      else
        if subscriber.size > 0
          merge_variables[:fname] = first_name if subscriber[0]['merges'].key?('FNAME') &&
              first_name &&
              subscriber[0]['merges']['FNAME'] != first_name
          merge_variables[:lname] = last_name if subscriber[0]['merges'].key?('LNAME') &&
              last_name.present? &&
              subscriber[0]['merges']['FNAME'] != last_name
        else
          merge_variables[:fname] = first_name if first_name.present?
          merge_variables[:lname] = last_name if last_name.present?
          merge_variables[:ip_address] = '101.0.79.50' #data_object.current_sign_in_ip
          merge_variables[:country] = UserCountryFromIP.new('101.0.79.50').country.country_name
        end

        merge_variables[:n_letter] = set_newsletter(current_email, subscriber)

        begin
          mailchimp.lists.subscribe(configatron.mailchimp.list_id, { "email" => current_email.email },
                                    merge_variables, 'html', false, true, true, false)
        rescue Mailchimp::ValidationError
          p "Here: Error"
        end
      end

      p mailchimp.lists
      p "Here: #{mailchimp.lists.members(configatron.mailchimp.list_id)}"
    end
  end

  def return_email_object(data_object)
    data_object
  end

  def email_changed?(current_email)
    return false if current_email.class.to_s == 'Contact'
    current_email.email_changed? && !current_email.email_was.blank?
  end

  def retrieve_first_name(c_email)
    first_name = nil
    if c_email.class.to_s == 'Contact'
      first_name = c_email.first_name
    else
      first_name = c_email.first_name if c_email.attributes.key?('first_name')
      first_name = c_email.firstname if c_email.attributes.key?('firstname')
    end
    first_name
  end

  def retrieve_last_name(c_email)
    last_name = nil
    if c_email.class.to_s == 'Contact'
      last_name = c_email.last_name
    else
      last_name = c_email.last_name if c_email.attributes.key?('last_name')
      last_name = c_email.lastname if c_email.attributes.key?('lastname')
    end
    last_name
  end

  def set_newsletter(c_email, subscriber)
    newsletter = (c_email.newsletter ? 'yes' : 'no') if activerecord?(c_email) && c_email.attributes.key?('newsletter')
    newsletter = 'no' if subscriber.size == 0 && !activerecord?(c_email)
    newsletter
  end

  def activerecord?(d_object)
    d_object.class.ancestors.include?(ActiveRecord::Base)
  end

end
