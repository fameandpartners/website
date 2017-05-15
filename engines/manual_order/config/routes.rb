ManualOrder::Engine.routes.draw do

  resources :manual_orders do
    collection do
      get 'colors/:product_id' => 'manual_orders#colors_options'
      get 'sizes/:product_id' => 'manual_orders#sizes_options'
      get 'heights/:product_id' => 'manual_orders#heights_options'
      get 'customisations/:product_id' => 'manual_orders#customisations_options'
      get 'images/:product_id/:color_id' => 'manual_orders#image'
      get 'prices/:product_id/:currency' => 'manual_orders#price'
      get 'autocomplete_customers' => 'manual_orders#autocomplete_customers'
      get 'user/:user_id' => 'manual_orders#user_data'
    end
  end

end
