if Rails.env.production?
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
  Features.deactivate(:enhanced_moodboards)
end

if Rails.env.preproduction?
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:enhanced_moodboards)
  Features.deactivate(:google_tag_manager)
  Features.deactivate(:test_analytics)
end

if Rails.env.test?
  Features.deactivate(:google_tag_manager)
  Features.deactivate(:marketing_modals)
  Features.deactivate(:test_analytics)
  Features.activate(:enhanced_moodboards)
end

Features.deactivate(:checkout_fb_login)
Features.deactivate(:maintenance)
Features.deactivate(:marketing_modals)
Features.deactivate(:shipping_message)
Features.deactivate(:send_promotion_email_reminder)


Features.activate(:express_making)
Features.activate(:gift)
Features.activate(:masterpass)
Features.activate(:moodboard)
Features.activate(:sales)
Features.activate(:style_quiz)
Features.activate(:delivery_date_messaging)
