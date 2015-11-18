if Rails.env.production?
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
end

if Rails.env.preproduction?
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.deactivate(:google_tag_manager)
  Features.deactivate(:test_analytics)
end

if Rails.env.test?
  Features.deactivate(:google_tag_manager)
  Features.deactivate(:marketing_modals)
  Features.deactivate(:test_analytics)
end

Features.deactivate(:checkout_fb_login)
Features.deactivate(:maintenance)
Features.deactivate(:shipping_message)
Features.deactivate(:send_promotion_email_reminder)

Features.activate(:marketing_modals)
Features.activate(:express_making)
Features.activate(:gift)
Features.activate(:masterpass)
Features.activate(:moodboard)
Features.activate(:sales)
Features.activate(:style_quiz)
