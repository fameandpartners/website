class MysteriousRouteController < ActionController::Base
  layout false

  # Captures and logs hits to weird URLs we keep seeing in the logs.
  # '/undefined' '/au/undefined'
  def undefined
    data = request.env.select {|key,_| key.upcase == key }

    NewRelic::Agent.record_custom_event("UndefinedURL", data)
    render :text => 'Not Found', :status => :not_found
  end
end
