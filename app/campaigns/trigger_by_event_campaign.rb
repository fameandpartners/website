# TriggerByEventCampaign to store trigger by event campaign attributes to cookies
# Campaign stores modal params in cookies
require 'base64'

class TriggerByEventCampaign < CampaignManager
  UUID = 'trigger_by_event'
  EVENT_NAME_PARAM = 'event_name'

  ALLOWED_EVENTS = %w[add-to-cart]

  def can_activate?
    return true if campaign_attrs[event_key].present?

    ALLOWED_EVENTS.include?(decode(campaign_attrs[event_key]))
  end

  def is_active?
    if ALLOWED_EVENTS.include?(campaign_attrs[:event_name])
      underscored_name = campaign_attrs[:event_name].underscore
      storage[:"trigger_by_event_data_#{underscored_name}"].present?
    end
  end

  def expired?
    false
  end

  def promotion
    nil
  end

  def activate!
    event_name = decode(campaign_attrs[event_key])
    underscored_name = event_name.underscore

    storage[:"trigger_by_event_data_#{underscored_name}"]       = dump_data(campaign_attrs)
    storage[:"trigger_by_event_started_at_#{underscored_name}"] = Time.now.to_i
  end

  def deactivate!
    if ALLOWED_EVENTS.include?(campaign_attrs[:event_name])
      underscored_name = campaign_attrs[:event_name].underscore
      return unless storage[:"trigger_by_event_data_#{underscored_name}"]

      storage.delete(:"trigger_by_event_data_#{underscored_name}")
      storage.delete(:"trigger_by_event_started_at_#{underscored_name}")
    end
  end

  def data
    underscored_name = campaign_attrs[:event_name].underscore
    Marshal.load(storage[:"trigger_by_event_data_#{underscored_name}"])
  end

  private

  def event_key
    ModalGenerator::ModalParams::TRIGGER_BY_EVENT.param
  end

  def dump_data(attrs)
    Marshal.dump(attrs)
  end

  # remove attributes that are not being used by modal generator
  def clear_attributes
    campaign_attrs.each do |key, value|
      key = key.to_s
      next if key == EVENT_NAME_PARAM

      if ModalGenerator::PARAM_LIST.exclude?(key.to_s)
        campaign_attrs.delete(key)
      end
    end
    campaign_attrs[:pop] = 'true'
  end
end
