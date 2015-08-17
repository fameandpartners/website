module MasterPassHelper
  def masterpass_js_tags(data)
    content = content_tag(:script, "", {type: "text/javascript", src: "#{data.omniture_url}"}).html_safe
    content << "\n" << content_tag(:script, "", {type: "text/javascript", src: "#{data.lightbox_url}"}).html_safe
    content
  end


  def masterpass_payment_method
    @masterpass_payment_method ||= Spree::PaymentMethod.where(
        type: "Spree::Gateway::MasterPass",
        environment: Rails.env,
        active: true,
        deleted_at: nil
    ).first
  end

  def masterpass_available?
    masterpass_payment_method.present?
  end
end
