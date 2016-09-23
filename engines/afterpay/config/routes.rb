Rails.application.routes.draw do
  namespace :afterpay do
    get '/confirm/:order_number', to: 'payments#new', as: :confirm
  end
end
