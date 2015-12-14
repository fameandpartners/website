# Please, aggregate flags by deactivated/activated groups, and sorted by alphabetical order
# This organization helps a lot on finding what's active or not on each env

Features.deactivate(:checkout_fb_login)
Features.deactivate(:content_revolution)
Features.deactivate(:delivery_date_messaging)
Features.deactivate(:enhanced_moodboards)
Features.deactivate(:fameweddings)
Features.deactivate(:maintenance)
Features.deactivate(:send_promotion_email_reminder)
Features.deactivate(:shipping_message)
Features.deactivate(:test_analytics)

Features.activate(:express_making)
Features.activate(:gift)
Features.activate(:google_tag_manager)
Features.activate(:marketing_modals)
Features.activate(:masterpass)
Features.activate(:moodboard)
Features.activate(:style_quiz)

if Rails.env.production?
  Features.activate(:redirect_to_com_au_domain)
end

if Rails.env.preproduction?
  Features.activate(:fameweddings)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:enhanced_moodboards)
  Features.activate(:fameweddings)

  Features.deactivate(:google_tag_manager)
  Features.deactivate(:test_analytics)
end

if Rails.env.test?
  Features.activate(:enhanced_moodboards)

  Features.deactivate(:google_tag_manager)
  Features.deactivate(:marketing_modals)
  Features.deactivate(:test_analytics)
end
