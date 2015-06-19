# AutoApplyPromoCampaign is used for campaigns where promotion with limited time interval
# should be automatically applied whenever product is added to cart
# This promotion stores information about itself in cookies
#   @auto_apply_promo_code [String]             - promotion code to be applied
#   @auto_apply_promo_code_duration [Integer]   - promotion duration in hours
#   @auto_apply_promo_code_started_at [Integer] - Time converted to integer
#   @auto_apply_promo_code_title [String]       - promotion title
#   @auto_apply_promo_code_message [String]     - promotion message
# In Modals generator one should additionally specify campaign_uuid=auto_apply_promo
# ClASS_NAME=vex-dialog-bottom vex-dialog-pink vex-text vex-dialog-pink-reverse

class AutoApplyPromoCampaign < CampaignManager
  UUID         = 'auto_apply_promo'
  ENCODED_UUID = 'YXV0b19hcHBseV9wcm9tbw=='

  def can_activate?
    # check already active or activated campaigns
    return false if campaign_attrs[:promo_started_at].blank? || campaign_attrs[:promocode].blank?
    return false if storage[:auto_apply_promo_code] && campaign_attrs[:promocode] == storage[:auto_apply_promo_code]

    if campaign_attrs[:duration].present?
      time = Time.at(campaign_attrs[:promo_started_at].to_i) + campaign_attrs[:duration].to_i.hours
      time >= Time.now
    else
      true
    end
  end

  def is_active?
    return false if storage[:auto_apply_promo_code].blank?

    if storage[:auto_apply_promo_code_duration].present?
      time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
      time >= Time.now
    else
      true
    end
  end

  def expired?
    return false if storage[:auto_apply_promo_code].blank?

    if storage[:auto_apply_promo_code_duration].present?
      time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
      time <= Time.now
    else
      false
    end
  end

  def promotion
    return unless is_active?
    @promotion ||= Spree::Promotion.find_by_code(storage[:auto_apply_promo_code])
  end

  def activate!
    storage[:auto_apply_promo_code]            = campaign_attrs[:promocode]
    storage[:auto_apply_promo_code_duration]   = campaign_attrs[:duration]
    storage[:auto_apply_promo_code_started_at] = campaign_attrs[:promo_started_at]
    storage[:auto_apply_promo_code_title]      = campaign_attrs[:title]
    storage[:auto_apply_promo_code_message]    = campaign_attrs[:message]
  end

  # clears out automatic promocodes with timers
  # clears out cookies and removes promotion adjustments current order
  def deactivate!
    return unless storage[:auto_apply_promo_code]
    return unless current_order

    time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
    return if time >= Time.now # promotion is still active

    current_order.adjustments.where(originator_type: 'Spree::PromotionAction').destroy_all

    storage.delete(:auto_apply_promo_code)
    storage.delete(:auto_apply_promo_code_duration)
    storage.delete(:auto_apply_promo_code_started_at)
    storage.delete(:auto_apply_promo_code_message)
    storage.delete(:auto_apply_promo_code_title)
  end

  def title
    storage[:auto_apply_promo_code_title]
  end

  def message
    storage[:auto_apply_promo_code_message]
  end

  def started_at
    storage[:auto_apply_promo_code_started_at]
  end

  def duration
    storage[:auto_apply_promo_code_duration]
  end

  private

  # check valid value for duration
  def clear_attributes
    if campaign_attrs[:duration].present? && campaign_attrs[:duration].to_s.to_i <= 0
      campaign_attrs.delete(:duration)
    end
  end
end
