AdminUi::Engine.routes.draw do


  resource  :payments_report,    :only => [:show, :create]
  root to: 'dashboard#index'
end
