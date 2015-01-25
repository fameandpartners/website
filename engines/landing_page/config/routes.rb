LandingPage::Engine.routes.draw do

  scope "(:site_version)", constraints: { site_version: /(us|au)/ } do
    match '/*path' => 'pages#index', :via => :get
  end

end
