class HackyMessagesController < ApplicationController
  # Temporary messaging for the having getitquick (fast making) turned off.
  # Uses some totes hacky Feature flag to control routes
  # :getitquick_unavailable
  def getitquick_unavailable
    title('Get it Quick', default_seo_title)
    @collection = Products::CollectionResource.new(fast_making: true).read

    render :getitquick_unavailable, status: :not_found
  end
end
