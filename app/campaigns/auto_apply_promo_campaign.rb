class AutoApplyPromoCampaign < CampaignManager
  def can_activate?
    # check already active or activated campaigns
    return false if storage[:auto_apply_promo_code]

    time = Time.at(campaign_attrs[:promo_started_at].to_i) + campaign_attrs[:duration].to_i.hours
    time >= Time.now
  end

  def is_active?
    if storage[:auto_apply_promo_code]
      time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
      time >= Time.now
    end
  end

  def expired?
    if storage[:auto_apply_promo_code]
      time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
      time <= Time.now
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
    return unless @current_order

    time = Time.at(storage[:auto_apply_promo_code_started_at].to_i) + storage[:auto_apply_promo_code_duration].to_i.hours
    return if time >= Time.now # promotion is still active

    current_order.adjustments.where(originator_type: 'Spree::PromotionAction').destroy_all

    storage.delete(:auto_apply_promo_code)
    storage.delete(:auto_apply_promo_code_duration)
    storage.delete(:auto_apply_promo_code_started_at)
    storage.delete(:auto_apply_promo_code_message)
    storage.delete(:auto_apply_promo_code_title)
  end
end
