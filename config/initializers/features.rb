if Rails.env.production?
  Features.activate(:masterpass)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:masterpass)
end

Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.activate(:sales)
Features.activate(:express_making)
Features.activate(:moodboard)
Features.activate(:order_returns)
