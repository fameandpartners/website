# Turns on global features
require 'redis'
Features.deactivate(:style_quiz)
Features.deactivate(:collection_content)
Features.deactivate(:maintenance)
Features.deactivate(:express_deliveries)
Features.activate(:moodboard)
Features.activate(:sales)
