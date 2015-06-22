AdminUi::Engine.routes.draw do
  resources :return_requests
  resource  :payments_report,    :only => [:show, :create]
  root to: 'dashboard#index'
end
