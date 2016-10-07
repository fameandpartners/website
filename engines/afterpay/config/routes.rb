Rails.application.routes.draw do
  namespace :afterpay do
    get '/confirm/:order_number', to: 'payments#new', as: :confirm
    get '/token/:payment_method_id/:order_number', to: 'token#new', as: :token, defaults: { format: :json }

    namespace :merchant_panel do
      get '/refund/:payment_id', to: redirect("#{Afterpay::AFTERPAY_MERCHANT_URL}/merchant/order/%{payment_id}"), as: :refund
    end
  end
end
