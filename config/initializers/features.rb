# Turns on global features
require 'redis'
Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.activate(:moodboard)
Features.activate(:express_deliveries)
Features.activate(:sales)
