Revolution::Engine.routes.draw do
  scope "(:locale)" do
    # match '/*path' => 'pages#index', :via => :get
  end

  resources :banners, only: [] do
    get :delete
  end
end
