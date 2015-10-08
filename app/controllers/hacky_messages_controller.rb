class HackyMessagesController < ApplicationController


  # Temporary messaging for the having getitquick (fast making) turned off.
  # Uses some totes hacky Feature flag to control routes
  # :getitquick_unavailable
  def getitquick_unavailable
    if Date.current > Date.parse('2015-10-07')
      NewRelic::Agent.notice_error('getitquick_unavailable is still active after expected re-enablement date (2015-10-07)')
    end
    @title = "Get It Quick " + default_seo_title
    @collection = Products::CollectionResource.new(fast_making: true).read
  end
end
