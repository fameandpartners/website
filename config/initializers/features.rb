if Rails.env.production?
  Features.deactivate(:masterpass)
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
end

if Rails.env.preproduction?
  Features.activate(:google_tag_manager)
  Features.activate(:masterpass)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:masterpass)
  Features.deactivate(:google_tag_manager)
end

Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.activate(:sales)
Features.activate(:express_making)
Features.activate(:moodboard)
Features.activate(:order_returns)
Features.deactivate(:send_promotion_email_reminder)
