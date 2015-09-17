if Rails.env.production?
  Features.deactivate(:masterpass)
end

if Rails.env.development?
  Features.activate(:content_revolution)
  Features.activate(:masterpass)
end

if Rails.env.production?
  Features.deactivate(:style_quiz)
else
  Features.activate(:style_quiz)
end

Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.activate(:sales)
Features.activate(:express_making)
Features.activate(:moodboard)
Features.activate(:order_returns)
