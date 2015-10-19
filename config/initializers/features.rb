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
end

Features.deactivate(:checkout_fb_login)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:shipping_message)
Features.deactivate(:send_promotion_email_reminder)

Features.activate(:express_making)
Features.activate(:masterpass)
Features.activate(:moodboard)
Features.activate(:sales)
Features.activate(:style_quiz)
