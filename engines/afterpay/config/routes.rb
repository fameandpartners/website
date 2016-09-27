Rails.application.routes.draw do
  namespace :afterpay do
    get '/confirm/:order_number', to: 'payments#new', as: :confirm

    namespace :merchant_panel do
      get '/refund/:payment_id', to: redirect("#{Afterpay::AFTERPAY_MERCHANT_URL}/merchant/order/%{payment_id}"), as: :refund
    end
  end
end
