CreateSend.api_key configatron.campaign_monitor.api_key

class CampaignMonitor
  # correctly, we should check sidekiq workers availability too
  def self.execute_immediately?
    Rails.env.development? || Rails.env.test?
  end

  def self.schedule(method, *args)
    if execute_immediately?
      CampaignMonitor.send(*args.unshift(method))
    else
      CampaignMonitor.delay.send(*args.unshift(method))
    end
  end

  def self.set_purchase_date(user, purchase_date, custom_fields = {})
    synchronize(
      user.email,
      user,
      custom_fields.merge('note' => "Purchase_date: #{ purchase_date.to_date.to_s }")
    )
  end

  def self.synchronize(email, user = nil, custom_fields = {})
    attributes = {}

    if user.present?
      attributes[:email] = user.email
      attributes[:full_name] = user.full_name
    else
      attributes[:email] = email
      attributes[:full_name] = ''
    end

    formatted_custom_fields = []

    custom_fields.each do |key, value|
      formatted_custom_fields.push({'Key' => key.to_s, 'Value' => value}) if value.present?
    end

    list_id = configatron.campaign_monitor.list_id

    subscriber = CreateSend::Subscriber.new(list_id, email)

    subscriber.update(attributes[:email], attributes[:full_name], formatted_custom_fields, false)

  rescue CreateSend::BadRequest => _e
    begin
      # Trying to update a subscriber often fails with an error,
      # which we seem to workaround by adding the user.
      #
      #   CreateSend::BadRequest:
      #     The CreateSend API responded with the following error -
      #     203: Subscriber not in list or has already been removed.
    CreateSend::Subscriber.add(list_id, attributes[:email], attributes[:full_name], formatted_custom_fields, false)
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  rescue StandardError => error
    NewRelic::Agent.notice_error(error)
  end
end
