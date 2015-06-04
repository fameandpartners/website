module PromosHelper
  def is_promo_48h_15_percent_off_active?
    @is_promo_48h_15_percent_off_active ||= begin
      ends_at_param_name = configatron.promo_48h_15_percent_off.ends_at_param_name
      ends_at = cookies[ends_at_param_name] ? Time.parse(cookies[ends_at_param_name]) : nil
      configatron.promo_48h_15_percent_off.enabled && cookies[ends_at_param_name] &&
        ends_at && ends_at > Time.now
    end
  end
end
