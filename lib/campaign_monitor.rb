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
      formatted_custom_fields.push({'Key' => key.to_s, 'Value' => value})
    end

    list_id = configatron.campaign_monitor.list_id

    subscriber = CreateSend::Subscriber.new(list_id, email)

    subscriber.update(attributes[:email], attributes[:full_name], formatted_custom_fields, false)
  rescue => exception
    CreateSend::Subscriber.add(list_id, attributes[:email], attributes[:full_name], formatted_custom_fields, false)
  end

  def self.set_purchase_date(user, purchase_date)
    list_id = configatron.campaign_monitor.list_id

    subscriber = CreateSend::Subscriber.new(list_id, user.email)

    formatted_custom_fields = [{
      'Key'   => 'note',
      'Value' => "Purchase_date: #{ purchase_date.to_date.to_s }"
    }]

    subscriber.update(user.email, user.full_name, formatted_custom_fields, false)
  rescue => exception
    user.synchronize_with_campaign_monitor!

    CampaignMonitor.delay.set_purchase_date(user, purchase_date)
  end
end
