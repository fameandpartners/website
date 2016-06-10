ManualOrder::Engine.routes.draw do

  resources :manual_orders do
    collection do
      get 'colors/:product_id' => 'manual_orders#colors_options_json'
      get 'sizes/:product_id' => 'manual_orders#sizes_options_json'
      get 'customisations/:product_id' => 'manual_orders#customisations_options_json'
    end
  end

end
