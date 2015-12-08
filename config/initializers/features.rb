# Please, aggregate flags by deactivated/activated groups, and sorted by alphabetical order
# This organization helps a lot on finding what's active or not on each env

Features.deactivate(:checkout_fb_login)
Features.deactivate(:content_revolution)
Features.deactivate(:maintenance)
Features.deactivate(:send_promotion_email_reminder)
Features.deactivate(:shipping_message)
Features.deactivate(:test_analytics)

Features.activate(:delivery_date_messaging)
Features.activate(:enhanced_moodboards)
Features.activate(:express_making)
Features.activate(:gift)
Features.activate(:google_tag_manager)
Features.activate(:marketing_modals)
Features.activate(:masterpass)
Features.activate(:moodboard)
Features.activate(:style_quiz)

if Rails.env.production?
end

if Rails.env.preproduction?
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:enhanced_moodboards)

  Features.deactivate(:google_tag_manager)
  Features.deactivate(:test_analytics)
end

if Rails.env.test?
  Features.activate(:enhanced_moodboards)

  Features.deactivate(:google_tag_manager)
  Features.deactivate(:marketing_modals)
  Features.deactivate(:test_analytics)
end
