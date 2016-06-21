ManualOrder::Engine.routes.draw do

  resources :manual_orders do
    collection do
      get 'colors/:product_id' => 'manual_orders#colors_options'
      get 'sizes/:product_id' => 'manual_orders#sizes_options'
      get 'customisations/:product_id' => 'manual_orders#customisations_options'
      get 'images/:product_id/:size_id/:color_id' => 'manual_orders#image'
      get 'prices/:product_id/:size_id/:color_id/:currency' => 'manual_orders#price'
      get 'autocomplete' => 'manual_orders#autocomplete'
    end
  end

end
