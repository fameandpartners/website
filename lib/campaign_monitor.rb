CreateSend.api_key configatron.campaign_monitor.api_key

class CampaignMonitor
  def self.synchronize(email, user = nil, custom_fields = {})
    attributes = {}

    if user.present?
      attributes.merge!(user.attributes.slice('full_name', 'email').symbolize_keys)
    else
      attributes[:email] = email
      attributes[:full_name] = ''
    end

    formatted_custom_fields = []

    custom_fields.each do |key, value|
      formatted_custom_fields.push({'Key' => key, 'Value' => value})
    end

    list_id = configatron.campaign_monitor.list_id

    subscriber = CreateSend::Subscriber.get(list_id, email)

    subscriber.update(attributes[:email], attributes[:full_name], formatted_custom_fields)
  rescue => exception
    CreateSend::Subscriber.add(list_id, attributes[:email], attributes[:full_name], formatted_custom_fields, false)
  end
end
